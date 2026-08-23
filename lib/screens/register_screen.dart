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

  String _gender = 'male';
  String? _bloodType;
  double? _lat;
  double? _lng;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _isLocating = false;
  bool _locationCaptured = false;
  bool _unknownBloodType = false;
  String? _locationError;

  static const List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
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
      _isLocating = true;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _locationError = 'Location services are disabled. Please enable GPS in settings.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationError = 'Location permission was denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationError = 'Location permission permanently denied. Enable in app settings.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
        _locationCaptured = true;
        _locationError = null;
      });
    } catch (e) {
      setState(() => _locationError = 'Could not capture location: $e');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_locationCaptured || _lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture your current location to match with nearby blood requests.'),
          backgroundColor: AppColors.crimson,
        ),
      );
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Privacy Policy to continue.'),
          backgroundColor: AppColors.crimson,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final donor = DonorModel(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        fin: _finController.text.trim(),
        gender: _gender,
        bloodType: _unknownBloodType ? 'unknown' : _bloodType,
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
      final errorMsg = e.toString();
      if (errorMsg.toLowerCase().contains('already registered')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Phone number is already registered.'),
            backgroundColor: AppColors.crimson,
            action: SnackBarAction(
              label: 'Log In',
              textColor: Colors.white,
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: AppColors.crimson),
        );
      }
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
        backgroundColor: AppColors.paper,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Badge & Title
                Center(
                  child: Column(
                    children: [
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
                          child: Icon(Icons.favorite_rounded, size: 32, color: AppColors.crimson),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Join Legash',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Register as a verified blood donor and save lives.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Full Name Field
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hintText: 'Abebe Bikila',
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                  validator: (v) => Validators.validateRequired(v, 'Name'),
                ),

                const SizedBox(height: AppSpacing.md),

                // Phone Number Field
                CustomTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hintText: '09XXXXXXXX or +2519XXXXXXXX',
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                  keyboardType: TextInputType.phone,
                  mono: true,
                  validator: Validators.validatePhone,
                ),

                const SizedBox(height: AppSpacing.md),

                // Fayda National ID (FIN)
                CustomTextField(
                  controller: _finController,
                  label: 'Fayda National ID (FIN)',
                  hintText: 'Enter your 16-digit Fayda FIN',
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textSecondary),
                  keyboardType: TextInputType.text,
                  mono: true,
                  validator: (v) => Validators.validateRequired(v, 'Fayda National ID (FIN)'),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Gender Selection (Modern Segmented Cards)
                Text(
                  'Gender',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderCard(
                        value: 'male',
                        label: 'Male',
                        icon: Icons.male_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildGenderCard(
                        value: 'female',
                        label: 'Female',
                        icon: Icons.female_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Blood Type Selection
                Text(
                  'Blood Type',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  decoration: BoxDecoration(
                    color: _unknownBloodType ? AppColors.paperDim : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.cardBorder, width: 1.2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _unknownBloodType ? null : _bloodType,
                      hint: Row(
                        children: [
                          const Icon(Icons.water_drop_outlined, color: AppColors.crimson, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            _unknownBloodType ? 'Unknown (Set later in profile)' : 'Select Blood Type',
                            style: TextStyle(
                              color: _unknownBloodType ? AppColors.textSecondary : AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                      items: _bloodTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.crimson.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                                child: Text(
                                  type,
                                  style: const TextStyle(
                                    color: AppColors.crimson,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Blood Type $type',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: _unknownBloodType
                          ? null
                          : (value) {
                              setState(() {
                                _bloodType = value;
                              });
                            },
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                // Unknown Blood Type Checkbox
                InkWell(
                  onTap: () {
                    setState(() {
                      _unknownBloodType = !_unknownBloodType;
                      if (_unknownBloodType) _bloodType = null;
                    });
                  },
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _unknownBloodType,
                          activeColor: AppColors.crimson,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (v) {
                            setState(() {
                              _unknownBloodType = v ?? false;
                              if (_unknownBloodType) _bloodType = null;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            "I don't know my blood type yet",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_unknownBloodType)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.sand.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 18, color: AppColors.inkSoft),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "You can find your blood type at your nearest hospital or donation center and update it in your profile anytime.",
                            style: TextStyle(color: AppColors.inkSoft, fontSize: 12, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: AppSpacing.lg),

                // Location Capture Card
                Text(
                  'Current Location',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _locationCaptured ? AppColors.pillGreen.withOpacity(0.3) : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: _locationCaptured ? AppColors.verified.withOpacity(0.5) : AppColors.cardBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _locationCaptured
                              ? AppColors.verified.withOpacity(0.12)
                              : AppColors.crimson.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _locationCaptured ? Icons.check_circle_outline : Icons.my_location,
                          color: _locationCaptured ? AppColors.verified : AppColors.crimson,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _locationCaptured ? 'Location Acquired' : 'GPS Location Required',
                              style: TextStyle(
                                color: _locationCaptured ? AppColors.verified : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _locationCaptured
                                  ? 'Lat: ${_lat!.toStringAsFixed(4)}, Lng: ${_lng!.toStringAsFixed(4)}'
                                  : 'Needed to notify you of nearby hospital emergencies',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _isLocating ? null : _captureLocation,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.crimson,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: _isLocating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.crimson),
                              )
                            : Text(_locationCaptured ? 'Update' : 'Capture'),
                      ),
                    ],
                  ),
                ),

                if (_locationError != null) ...[
                  const SizedBox(height: 6),
                  Text(_locationError!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
                ],

                const SizedBox(height: AppSpacing.lg),

                // Terms & Policy Checkbox
                InkWell(
                  onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.crimson,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                                fontSize: 13.5,
                              ),
                              children: const [
                                TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms of Service & Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.crimson,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
                    onPressed: _isLoading ? null : _submit,
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
                            'Create Account',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Footer Link
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
      ),
    );
  }

  Widget _buildGenderCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _gender == value;

    return InkWell(
      onTap: () => setState(() => _gender = value),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.crimson.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.crimson : AppColors.cardBorder,
            width: isSelected ? 2.0 : 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.crimson : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.crimson : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}