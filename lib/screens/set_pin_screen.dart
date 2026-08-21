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

class _SetPinScreenState extends State<SetPinScreen> {
  static const int _pinLength = 4;

  final List<TextEditingController> _pinControllers =
      List.generate(_pinLength, (_) => TextEditingController());
  final List<FocusNode> _pinFocusNodes =
      List.generate(_pinLength, (_) => FocusNode());

  final List<TextEditingController> _confirmControllers =
      List.generate(_pinLength, (_) => TextEditingController());
  final List<FocusNode> _confirmFocusNodes =
      List.generate(_pinLength, (_) => FocusNode());

  bool _isLoading = false;
  bool _hasError = false;
  bool _confirmError = false;
  String? _errorMsg;

  String get _pin => _pinControllers.map((c) => c.text).join();
  String get _confirmPin => _confirmControllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _pinFocusNodes) {
      f.dispose();
    }
    for (final c in _confirmControllers) {
      c.dispose();
    }
    for (final f in _confirmFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onPinDigitChanged(int index, String value, {required bool isConfirm}) {
    final focusNodes = isConfirm ? _confirmFocusNodes : _pinFocusNodes;

    setState(() {
      if (isConfirm) {
        _confirmError = false;
      } else {
        _hasError = false;
        _errorMsg = null;
      }
    });

    if (value.isNotEmpty) {
      if (index < _pinLength - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
        if (!isConfirm) {
          _confirmFocusNodes[0].requestFocus();
        }
      }
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _submit() async {
    final pin = _pin;
    final confirmPin = _confirmPin;

    if (pin.length < _pinLength) {
      setState(() => _hasError = true);
      return;
    }
    if (confirmPin.length < _pinLength) {
      setState(() => _confirmError = true);
      return;
    }
    if (pin != confirmPin) {
      setState(() {
        _hasError = true;
        _confirmError = true;
        _errorMsg = 'PINs do not match';
      });
      return;
    }

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
            content: Text('PIN set successfully! Welcome to Legash.'),
            backgroundColor: AppColors.verified,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
      } else {
        _onError(res['message'] as String? ?? 'Failed to set PIN.');
      }
    } catch (e) {
      if (!mounted) return;
      _onError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onError(String message) {
    setState(() => _errorMsg = message);
    for (final c in _pinControllers) {
      c.clear();
    }
    for (final c in _confirmControllers) {
      c.clear();
    }
    _pinFocusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text('Set PIN'),
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xs),
              const Icon(Icons.pin_outlined, size: 48, color: AppColors.crimson),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Set your 4-digit PIN',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  height: 32 / 26,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'This PIN will be used to unlock the app each time you open it, like a banking app.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 22 / 15,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Enter PIN',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildPinRow(_pinControllers, _pinFocusNodes, false),
              if (_hasError && _errorMsg != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _errorMsg!,
                  style: const TextStyle(color: AppColors.crimson, fontSize: 13),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Confirm PIN',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildPinRow(_confirmControllers, _confirmFocusNodes, true),
              if (_confirmError) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _hasError ? '' : 'PINs do not match',
                  style: const TextStyle(color: AppColors.crimson, fontSize: 13),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isLoading ? null : _submit,
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
                        'Set PIN & Continue',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinRow(
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
    bool isConfirm,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_pinLength, (index) {
        final focused = focusNodes[index].hasFocus;
        final hasError = isConfirm ? _confirmError : (_hasError || _errorMsg != null);
        return Container(
          width: 64,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: hasError
                  ? AppColors.crimson
                  : focused
                      ? AppColors.crimson
                      : AppColors.border,
              width: (hasError || focused) ? 2.0 : 1.2,
            ),
          ),
          child: Center(
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
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
              onChanged: (value) => _onPinDigitChanged(index, value, isConfirm: isConfirm),
            ),
          ),
        );
      }),
    );
  }
}
