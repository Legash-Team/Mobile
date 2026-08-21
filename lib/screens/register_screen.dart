import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import '../models/donor_model.dart';
import '../utils/validators.dart';
import '../utils/phone_formatter.dart';
import '../widgets/custom_text_field.dart';
import 'terms_policy_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _finController = TextEditingController();

  String? _gender;
  String? _bloodType;
  double? _lat;
  double? _lng;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _locationCaptured = false;
  bool _unknownBloodType = false;
  String? _locationError;

  static const List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'unknown',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _finController.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    setState(() {
      _locationError = null;
      _isLoading = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationError = 'Location services are disabled. Enable them in settings.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationError = 'Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationError = 'Location permission permanently denied. Enable in settings.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
        _locationCaptured = true;
      });
    } catch (e) {
      setState(() => _locationError = 'Could not capture location: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select gender'), backgroundColor: AppColors.crimson),
      );
      return;
    }
    if (!_locationCaptured || _lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture your location'), backgroundColor: AppColors.crimson),
      );
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms & Policy'), backgroundColor: AppColors.crimson),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final donor = DonorModel(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        fin: _finController.text.trim(),
        gender: _gender!,
        bloodType: _bloodType,
        lat: _lat!,
        lng: _lng!,
        agreedToTerms: _agreedToTerms,
      );

      await AuthService.registerDonor(donor);

      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: PhoneFormatter.format(_phoneController.text),
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
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text('Create Account'),
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'lib/legashicon.jpg',
                  height: 72,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Join Legash',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  height: 30 / 24,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Register as a blood donor and help save lives.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 22 / 15,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                validator: (v) => Validators.validateRequired(v, 'Name'),
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
              const SizedBox(height: AppSpacing.md),

              CustomTextField(
                controller: _finController,
                label: 'Fayda National ID (FIN)',
                keyboardType: TextInputType.text,
                mono: true,
                validator: (v) => Validators.validateRequired(v, 'FIN'),
              ),
              const SizedBox(height: AppSpacing.md),

              Text(
                'Gender',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              RadioGroup<String>(
                groupValue: _gender,
                onChanged: (v) => setState(() => _gender = v),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Male'),
                        leading: Radio<String>(value: 'male'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Female'),
                        leading: Radio<String>(value: 'female'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              DropdownButtonFormField<String>(
                initialValue: _bloodType,
                decoration: InputDecoration(
                  labelText: 'Blood Type',
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide(color: AppColors.borderFocused, width: 2),
                  ),
                ),
                items: _bloodTypes.where((t) => t != 'unknown').map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: _unknownBloodType ? null : (v) => setState(() => _bloodType = v),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Checkbox(
                    value: _unknownBloodType,
                    activeColor: AppColors.crimson,
                    onChanged: (v) => setState(() {
                      _unknownBloodType = v ?? false;
                      if (_unknownBloodType) _bloodType = null;
                    }),
                  ),
                  const Expanded(
                    child: Text(
                      "I don't know my blood type",
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (_unknownBloodType)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.paperDim,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Text(
                    "Enter your blood type in your profile later to receive donation requests. You can find out your blood type at the nearest blood donation center.",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 18 / 13),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _captureLocation,
                      icon: const Icon(Icons.location_on, color: AppColors.crimson),
                      label: Text(
                        _locationCaptured
                            ? 'Location Captured (${_lat!.toStringAsFixed(4)}, ${_lng!.toStringAsFixed(4)})'
                            : 'Get Current Location',
                        style: const TextStyle(color: AppColors.crimson),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        side: const BorderSide(color: AppColors.crimson, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              if (_locationError != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(_locationError!, style: TextStyle(color: AppColors.error, fontSize: 13)),
              ],
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.crimson,
                    onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsPolicyScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms & Privacy Policy',
                              style: TextStyle(
                                color: AppColors.crimson,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
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
                          'Register',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
                            const SizedBox(height: AppSpacing.lg),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.inkSoft, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: AppColors.crimson,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

            ],
          ),
        ),
      ),
    );
  }
}