import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/donor_model.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class SetPinScreen extends StatefulWidget {
  final String phone;

  const SetPinScreen({super.key, required this.phone});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> with SingleTickerProviderStateMixin {
  static const int _pinLength = 4;

  // 1 = Enter PIN, 2 = Confirm PIN
  int _step = 1;

  final List<TextEditingController> _controllers =
      List.generate(_pinLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_pinLength, (_) => FocusNode());

  String _firstPin = '';
  bool _isLoading = false;
  bool _hasError = false;
  bool _obscurePin = true;
  String? _errorMessage;

  String get _currentPin => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _clearInputs() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _onDigitChanged(int index, String value) {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });

    if (value.isNotEmpty) {
      HapticFeedback.selectionClick();
      if (index < _pinLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        if (_currentPin.length == _pinLength) {
          _onPinComplete();
        }
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onPinComplete() {
    if (_step == 1) {
      _firstPin = _currentPin;
      setState(() {
        _step = 2;
        _hasError = false;
        _errorMessage = null;
      });
      _clearInputs();
    } else {
      final confirmPin = _currentPin;
      if (confirmPin != _firstPin) {
        HapticFeedback.heavyImpact();
        setState(() {
          _hasError = true;
          _errorMessage = 'PINs do not match. Please try again.';
          _step = 1;
          _firstPin = '';
        });
        _clearInputs();
      } else {
        _submitPin(_firstPin, confirmPin);
      }
    }
  }

  Future<void> _submitPin(String pin, String confirmPin) async {
    setState(() => _isLoading = true);

    try {
      final res = await AuthService.setPin(widget.phone, pin, confirmPin);

      if (!mounted) return;

      if (res['success'] == true && res['token'] != null) {
        final token = res['token'] as String;
        final donor = DonorInfo.fromJson(res['donor'] as Map<String, dynamic>);
        context.read<AuthProvider>().login(token, donor);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN created successfully! Welcome to Legash.'),
            backgroundColor: AppColors.verified,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      } else {
        _onError(res['message'] as String? ?? 'Failed to set PIN. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _onError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onError(String message) {
    HapticFeedback.heavyImpact();
    setState(() {
      _hasError = true;
      _errorMessage = message;
      _step = 1;
      _firstPin = '';
    });
    _clearInputs();
  }

  void _goBackToStep1() {
    setState(() {
      _step = 1;
      _firstPin = '';
      _hasError = false;
      _errorMessage = null;
    });
    _clearInputs();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text('Security PIN'),
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_step == 2) {
              _goBackToStep1();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.sm),

              // Step Progress Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.crimson.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.crimson.withOpacity(0.18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.crimson,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _step == 1 ? 'Step 1 of 2: Create PIN' : 'Step 2 of 2: Confirm PIN',
                      style: const TextStyle(
                        color: AppColors.crimson,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Security Shield Icon
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
                    Icons.shield_outlined,
                    size: 32,
                    color: AppColors.crimson,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Heading & Subtitle
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Column(
                  key: ValueKey<int>(_step),
                  children: [
                    Text(
                      _step == 1 ? 'Create your 4-digit PIN' : 'Confirm your PIN',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _step == 1
                          ? 'Choose a memorable 4-digit PIN to securely unlock the Legash app on this device.'
                          : 'Please re-enter the same 4-digit PIN to confirm.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Error Message Banner
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

              // 4-Digit Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (index) {
                  final hasFocus = _focusNodes[index].hasFocus;
                  final hasValue = _controllers[index].text.isNotEmpty;

                  return Container(
                    width: 60,
                    height: 68,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: _hasError
                            ? AppColors.crimson
                            : hasFocus
                                ? AppColors.crimson
                                : hasValue
                                    ? AppColors.crimson.withOpacity(0.5)
                                    : AppColors.cardBorder,
                        width: hasFocus || _hasError ? 2.0 : 1.4,
                      ),
                      boxShadow: [
                        if (hasFocus)
                          BoxShadow(
                            color: AppColors.crimson.withOpacity(0.12),
                            blurRadius: 10,
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
                        obscureText: _obscurePin,
                        obscuringCharacter: '●',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: AppFonts.mono,
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
                          contentPadding: EdgeInsets.zero,
                          counterText: '',
                        ),
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.md),

              // Visibility Peek Toggle
              TextButton.icon(
                onPressed: () => setState(() => _obscurePin = !_obscurePin),
                icon: Icon(
                  _obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                label: Text(
                  _obscurePin ? 'Show PIN' : 'Hide PIN',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (_step == 2) ...[
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: _goBackToStep1,
                  child: const Text(
                    'Change initial PIN',
                    style: TextStyle(
                      color: AppColors.crimson,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Primary Action Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_currentPin.length == _pinLength) {
                            _onPinComplete();
                          } else {
                            setState(() {
                              _hasError = true;
                              _errorMessage = 'Please enter all 4 digits.';
                            });
                          }
                        },
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
                      : Text(
                          _step == 1 ? 'Continue to Confirm' : 'Confirm & Save PIN',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Security Guarantee Note
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.paperDim,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, size: 20, color: AppColors.verified),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your PIN is securely hashed and protected. Never share your PIN with anyone.',
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
}
