import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/donor_model.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../utils/phone_formatter.dart';
import '../widgets/custom_text_field.dart';

class PinUnlockScreen extends StatefulWidget {
  const PinUnlockScreen({super.key});

  @override
  State<PinUnlockScreen> createState() => _PinUnlockScreenState();
}

class _PinUnlockScreenState extends State<PinUnlockScreen> {
  static const int _pinLength = 4;

  final _phoneController = TextEditingController();
  final List<TextEditingController> _pinControllers =
      List.generate(_pinLength, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes =
      List.generate(_pinLength, (_) => FocusNode());

  bool _isLoading = false;
  bool _hasError = false;
  int _attempts = 0;

  String get _pin => _pinControllers.map((c) => c.text).join();

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    setState(() => _hasError = false);
    if (value.isNotEmpty) {
      if (index < _pinLength - 1) {
        _pinFocusNodes[index + 1].requestFocus();
      } else {
        _pinFocusNodes[index].unfocus();
        _unlock();
      }
    } else if (value.isEmpty && index > 0) {
      _pinFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _unlock() async {
    final pin = _pin;
    if (pin.length < _pinLength) return;

    setState(() => _isLoading = true);

    try {
      final res = await AuthService.unlock(_phoneController.text, pin);

      if (!mounted) return;

      if (res['success'] == true && res['token'] != null) {
        final token = res['token'] as String;
        final donorData = res['donor'] as Map<String, dynamic>?;
        final donor = donorData != null ? DonorInfo.fromJson(donorData) : null;

        context.read<AuthProvider>().login(token, donor ?? DonorInfo(
          id: '',
          name: 'Donor',
          phone: '',
        ));
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      } else {
        _onError();
      }
    } catch (e) {
      if (!mounted) return;
      _onError();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onError() {
    _attempts++;
    setState(() => _hasError = true);
    for (final c in _pinControllers) {
      c.clear();
    }
    _pinFocusNodes[0].requestFocus();

    if (_attempts >= 3) {
      _showForgotPinDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect PIN. ${3 - _attempts} attempts remaining.'),
          backgroundColor: AppColors.crimson,
        ),
      );
    }
  }

  void _showForgotPinDialog() {
    showDialog(
      context: context,
      builder: (_) => const ForgotPinDialog(),
    ).then((result) {
      if (result == true) {
        setState(() => _attempts = 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Image.asset('lib/legashicon.jpg', height: 72),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Welcome Back',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter your 4-digit PIN to unlock',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone',
                hintText: '0XXXXXXXXX',
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_pinLength, (index) {
                  final focused = _pinFocusNodes[index].hasFocus;
                  return Container(
                    width: 64,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: _hasError
                            ? AppColors.crimson
                            : focused
                                ? AppColors.crimson
                                : AppColors.border,
                        width: (_hasError || focused) ? 2.0 : 1.2,
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _pinControllers[index],
                        focusNode: _pinFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        obscureText: true,
                        obscuringCharacter: '•',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        enabled: !_isLoading,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isLoading ? null : _unlock,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.crimson,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                        'Unlock',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: _showForgotPinDialog,
                child: const Text(
                  'Forgot PIN?',
                  style: TextStyle(color: AppColors.crimson, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                child: const Text(
                  "Don't have an account? Create one",
                  style: TextStyle(color: AppColors.crimson, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPinDialog extends StatefulWidget {
  const ForgotPinDialog({super.key});

  @override
  State<ForgotPinDialog> createState() => _ForgotPinDialogState();
}

class _ForgotPinDialogState extends State<ForgotPinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  String _step = 'phone';
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService.forgotPin(_phoneController.text.trim());
      if (!mounted) return;
      setState(() => _step = 'otp');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.crimson),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPin() async {
    if (!_formKey.currentState!.validate()) return;
    final pin = _pinController.text;
    final confirmPin = _confirmPinController.text;
    if (pin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match'), backgroundColor: AppColors.crimson),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService.resetPin(
        _phoneController.text.trim(),
        _otpCode,
        pin,
        confirmPin,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN reset successfully. Please log in with your new PIN.'),
          backgroundColor: AppColors.verified,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.crimson),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: AppColors.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (_step != 'phone')
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
                      onPressed: () => setState(() {
                        if (_step == 'otp') _step = 'phone';
                        if (_step == 'pin') _step = 'otp';
                      }),
                    ),
                  Expanded(
                    child: Text(
                      _step == 'phone'
                          ? 'Forgot PIN'
                          : _step == 'otp'
                              ? 'Verify OTP'
                              : 'Set New PIN',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_step == 'phone') ...[
                Text(
                  'Enter your phone number and we will send you an OTP to reset your PIN.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hintText: '09XXXXXXXX or +2519XXXXXXXX',
                  keyboardType: TextInputType.phone,
                  mono: true,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: _isLoading ? null : _sendOtp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Send OTP'),
                ),
              ] else if (_step == 'otp') ...[
                Text(
                  'Enter the 6-digit code sent to ${PhoneFormatter.format(_phoneController.text)}',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 44,
                      height: 52,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _otpFocusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _otpFocusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: _isLoading
                      ? null
                      : _otpCode.length == 6
                          ? () => setState(() => _step = 'pin')
                          : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Continue'),
                ),
              ] else ...[
                Text(
                  'Choose a new 4-digit PIN.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _pinController,
                  label: 'New PIN',
                  hintText: 'Enter 4-digit PIN',
                  keyboardType: TextInputType.number,
                  mono: true,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length != 4) return 'PIN must be 4 digits';
                    if (!RegExp(r'^\d{4}$').hasMatch(v)) return 'PIN must be digits only';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _confirmPinController,
                  label: 'Confirm PIN',
                  hintText: 'Re-enter 4-digit PIN',
                  keyboardType: TextInputType.number,
                  mono: true,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length != 4) return 'PIN must be 4 digits';
                    if (v != _pinController.text) return 'PINs do not match';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: _isLoading ? null : _resetPin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Reset PIN'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
