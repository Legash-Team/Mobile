import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import 'custom_text_field.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String? initialPhone;

  const ForgotPasswordDialog({super.key, this.initialPhone});

  static Future<String?> show(BuildContext context, {String? initialPhone}) {
    return showDialog<String>(
      context: context,
      builder: (_) => ForgotPasswordDialog(initialPhone: initialPhone),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _step = 'request';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPhone != null) {
      _phoneController.text = widget.initialPhone!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.forgotPassword(_phoneController.text.trim());
      if (!mounted) return;
      setState(() => _step = 'verify');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.crimson),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.resetPassword(
        _phoneController.text.trim(),
        _codeController.text.trim(),
        _newPasswordController.text,
      );
      if (!mounted) return;
      Navigator.pop(context, _phoneController.text.trim());
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
                  if (_step == 'verify')
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
                      onPressed: () => setState(() => _step = 'request'),
                    ),
                  Expanded(
                    child: Text(
                      _step == 'request' ? 'Forgot Password?' : 'Reset Password',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 26 / 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              if (_step == 'request') ...[
                Text(
                  'Enter your phone number and we will send you an OTP to reset your password.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 20 / 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hintText: '+2519XXXXXXXX',
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
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.verified.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.verified, size: 20),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'If an account exists with that phone number, an OTP has been sent.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.verified,
                            fontSize: 13,
                            height: 18 / 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _codeController,
                  label: 'OTP Code',
                  hintText: 'Enter 6-digit code',
                  keyboardType: TextInputType.number,
                  mono: true,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'OTP code is required';
                    if (v.trim().length < 4) return 'Enter a valid code';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  obscureText: true,
                  validator: (v) =>
                      Validators.validateConfirmPassword(v, _newPasswordController.text),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Reset Password'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
