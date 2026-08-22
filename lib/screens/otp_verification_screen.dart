import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../services/auth_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;

  const OtpVerificationScreen({super.key, required this.phone});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _boxCount = 6;
  static const int _resendSeconds = 60;

  final List<TextEditingController> _controllers =
      List.generate(_boxCount, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_boxCount, (_) => FocusNode());

  Timer? _timer;
  int _countdown = _resendSeconds;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _countdown = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendCode() async {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });

    try {
      await AuthService.resendOtp(widget.phone);
      _startTimer();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A fresh 6-digit OTP has been sent to your phone.'),
          backgroundColor: AppColors.verified,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.crimson),
      );
    }
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    final code = _otpCode;
    if (code.length < _boxCount) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please enter all 6 digits.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final res = await AuthService.verifyOtp(widget.phone, code);

      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number verified! Now create your 4-digit PIN.'),
            backgroundColor: AppColors.verified,
          ),
        );
        Navigator.pushReplacementNamed(
          context,
          '/set-pin',
          arguments: widget.phone,
        );
      } else {
        _onVerificationFailed(res['error'] as String? ?? 'Invalid verification code.');
      }
    } catch (e) {
      if (!mounted) return;
      _onVerificationFailed(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onVerificationFailed(String message) {
    HapticFeedback.heavyImpact();
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  void _onDigitChanged(int index, String value) {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });

    if (value.isNotEmpty) {
      HapticFeedback.selectionClick();
      if (index < _boxCount - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (_otpCode.length == _boxCount) {
          _verify();
        }
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text('OTP Verification'),
        foregroundColor: AppColors.textPrimary,
        backgroundColor: AppColors.paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.sm),

              // Header Badge
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ink.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    size: 32,
                    color: AppColors.crimson,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Title & Subtitle
              Text(
                'Verify your phone',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'We sent a 6-digit SMS verification code to',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.phone,
                    style: const TextStyle(
                      fontFamily: AppFonts.mono,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.crimson,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Error Banner
              if (_hasError && _errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.crimson.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 18, color: AppColors.crimson),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.crimson,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // 6-Digit OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_boxCount, _buildOtpBox),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Resend Timer / Action
              Center(
                child: Column(
                  children: [
                    Text(
                      'Did not receive the code?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_countdown > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.paperDim,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Resend code in 00:${_countdown.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontFamily: AppFonts.mono,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      TextButton.icon(
                        onPressed: _resendCode,
                        icon: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.crimson),
                        label: const Text(
                          'Resend Code',
                          style: TextStyle(
                            color: AppColors.crimson,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Primary CTA Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _verify,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.crimson,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Verify & Continue',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Security Guarantee Footer
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.paperDim,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 20, color: AppColors.verified),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your OTP is confidential. Never forward or share this code with anyone.',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.85),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final hasFocus = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    return Container(
      width: 48,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _hasError
              ? AppColors.crimson
              : hasFocus
                  ? AppColors.crimson
                  : hasValue
                      ? AppColors.crimson.withOpacity(0.4)
                      : AppColors.cardBorder,
          width: hasFocus || _hasError ? 2.0 : 1.3,
        ),
        boxShadow: [
          if (hasFocus)
            BoxShadow(
              color: AppColors.crimson.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.mono,
            color: AppColors.textPrimary,
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          enabled: !_isLoading,
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => _onDigitChanged(index, value),
        ),
      ),
    );
  }
}
