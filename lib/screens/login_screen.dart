import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/donor_model.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../utils/phone_formatter.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/forgot_password_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final res = await AuthService.loginDonor(
        _phoneController.text.trim(),
        _passwordController.text,
      );

      final data = res['data'] as Map<String, dynamic>;
      final token = data['token'] as String;
      final donor = DonorInfo.fromJson(data['donor'] as Map<String, dynamic>);

      if (!mounted) return;
      context.read<AuthProvider>().login(token, donor);
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    } catch (e) {
      if (!mounted) return;
      final message = e.toString();
      final isNotVerified = message.toLowerCase().contains('not verified');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.crimson,
          action: isNotVerified
                ? SnackBarAction(
                    label: 'Verify OTP',
                    textColor: Colors.white,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/otp',
                      arguments: PhoneFormatter.format(_phoneController.text),
                    ),
                  )
              : null,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openForgotPassword() async {
    final phone = await ForgotPasswordDialog.show(
      context,
      initialPhone: _phoneController.text.trim(),
    );
    if (!mounted || phone == null) return;
    _phoneController.text = phone;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset successfully. Please log in with your new password.'),
        backgroundColor: AppColors.verified,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text('Log In'),
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Image.asset(
                  'lib/legashicon.jpg',
                  height: 72,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  height: 30 / 24,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Log in to find donors and manage your donations.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hintText: '09XXXXXXXX or +2519XXXXXXXX',
                keyboardType: TextInputType.phone,
                mono: true,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: AppSpacing.md),

              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                validator: (v) => Validators.validateRequired(v, 'Password'),
              ),
              const SizedBox(height: AppSpacing.xs),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _openForgotPassword,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: AppColors.crimson, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              FilledButton(
                onPressed: _isLoading ? null : _login,
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
                        'Log In',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: AppColors.crimson,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
