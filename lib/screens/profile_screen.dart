import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/donor_model.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const List<String> _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'D';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Future<void> _updateField(String key, dynamic value, String successMessage) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      await AuthService.updateProfile({key: value});

      final res = await AuthService.getProfile();
      if (res['success'] == true && res['profile'] != null) {
        final updatedDonor = DonorInfo.fromJson(res['profile']);
        auth.updateDonor(updatedDonor);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: AppColors.verified,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: AppColors.crimson,
          ),
        );
      }
    }
  }

  void _showBloodTypePicker(String? currentType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.water_drop, color: AppColors.crimson, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Select Blood Type',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Choose your certified ABO and Rh blood group.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _bloodTypes.length,
                  itemBuilder: (context, index) {
                    final type = _bloodTypes[index];
                    final isSelected = currentType?.toUpperCase() == type;

                    return InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _updateField('bloodType', type, 'Blood type updated to $type');
                      },
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.crimson : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: isSelected ? AppColors.crimson : AppColors.cardBorder,
                            width: 1.5,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.crimson.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGenderPicker(String? currentGender) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Gender',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildChoiceTile(
                  title: 'Male',
                  icon: Icons.male_rounded,
                  isSelected: (currentGender ?? '').toLowerCase() == 'male',
                  onTap: () {
                    Navigator.pop(ctx);
                    _updateField('gender', 'male', 'Gender updated to Male');
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildChoiceTile(
                  title: 'Female',
                  icon: Icons.female_rounded,
                  isSelected: (currentGender ?? '').toLowerCase() == 'female',
                  onTap: () {
                    Navigator.pop(ctx);
                    _updateField('gender', 'female', 'Gender updated to Female');
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChoiceTile({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.crimson.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.crimson : AppColors.cardBorder,
            width: isSelected ? 2.0 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.crimson : AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.crimson : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.crimson, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePickerDialog(String? currentDob) async {
    DateTime initialDate = DateTime(1995, 1, 1);
    if (currentDob != null) {
      try {
        initialDate = DateTime.parse(currentDob);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1930),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)), // At least 16 yrs
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.crimson,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = picked.toIso8601String().split('T')[0];
      _updateField('dob', formatted, 'Date of birth updated');
    }
  }

  void _showNumberInputDialog({
    required String title,
    required String field,
    required String unit,
    required num? currentValue,
    required int min,
    required int max,
  }) {
    final controller = TextEditingController(text: currentValue != null ? '$currentValue' : '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your $title in $unit ($min - $max $unit):',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: AppFonts.mono),
                decoration: InputDecoration(
                  suffixText: unit,
                  filled: true,
                  fillColor: AppColors.paperDim,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.crimson, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            FilledButton(
              onPressed: () {
                final val = int.tryParse(controller.text.trim());
                if (val == null || val < min || val > max) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a value between $min and $max $unit.'),
                      backgroundColor: AppColors.crimson,
                    ),
                  );
                  return;
                }
                Navigator.pop(ctx);
                _updateField(field, val, '$title updated to $val $unit');
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.crimson,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showTextEditDialog({
    required String title,
    required String field,
    required String currentValue,
    int maxLines = 1,
  }) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: TextField(
            controller: controller,
            maxLines: maxLines,
            autofocus: true,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.paperDim,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: const BorderSide(color: AppColors.crimson, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            FilledButton(
              onPressed: () {
                final val = controller.text.trim();
                Navigator.pop(ctx);
                _updateField(field, val, '$title updated');
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.crimson,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangePinDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const ChangePinDialog(),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN changed successfully.'),
          backgroundColor: AppColors.verified,
        ),
      );
    }
  }

  Future<void> _showLogoutDialog(AuthProvider auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: const Text(
          'Are you sure you want to log out of your account on this device?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.crimson,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final nav = Navigator.of(context);
      await auth.logout();
      if (!mounted) return;
      nav.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final donor = auth.donor;

    final name = donor?.name ?? 'Donor';
    final phone = donor?.phone ?? 'Not set';
    final fin = donor?.fin ?? 'Not set';
    final bloodType = donor?.bloodType ?? '';
    final gender = donor?.gender ?? 'male';
    final dob = donor?.dob != null ? donor!.dob!.split('T')[0] : 'Not set';
    final weight = donor?.weightKg != null ? '${donor!.weightKg} kg' : 'Not set';
    final height = donor?.heightCm != null ? '${donor!.heightCm} cm' : 'Not set';
    final healthNotes = (donor?.healthNotes?.isNotEmpty == true) ? donor!.healthNotes! : 'None';

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(
            color: AppColors.crimson,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.crimson,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        children: [
          // Donor Profile Header Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.crimson.withOpacity(0.1),
                  child: Text(
                    _getInitials(name),
                    style: const TextStyle(
                      color: AppColors.crimson,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(
                    fontFamily: AppFonts.mono,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.pillGreen,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, color: AppColors.verified, size: 15),
                          SizedBox(width: 4),
                          Text(
                            'Verified Donor',
                            style: TextStyle(
                              color: AppColors.verified,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (bloodType.isNotEmpty && bloodType.toLowerCase() != 'unknown')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.crimson.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.water_drop, color: AppColors.crimson, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Type $bloodType',
                              style: const TextStyle(
                                color: AppColors.crimson,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.sand.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Text(
                          'Blood Type Unset',
                          style: TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Section 1: Personal Details
          const Text(
            'Personal Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                _buildActionTile(
                  icon: Icons.person_outline,
                  label: 'Full Name',
                  value: name,
                  onTap: () => _showTextEditDialog(
                    title: 'Full Name',
                    field: 'name',
                    currentValue: name,
                  ),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _buildActionTile(
                  icon: Icons.water_drop_outlined,
                  label: 'Blood Type',
                  value: bloodType.isEmpty || bloodType == 'unknown' ? 'Tap to select' : bloodType,
                  isHighlight: bloodType.isEmpty || bloodType == 'unknown',
                  onTap: () => _showBloodTypePicker(bloodType),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _buildActionTile(
                  icon: Icons.wc_outlined,
                  label: 'Gender',
                  value: gender.toUpperCase(),
                  onTap: () => _showGenderPicker(gender),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _buildReadOnlyTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: phone,
                  mono: true,
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _buildReadOnlyTile(
                  icon: Icons.badge_outlined,
                  label: 'Fayda National ID (FIN)',
                  value: fin,
                  mono: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Section 2: Medical & Physical Details
          const Text(
            'Medical & Physical Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                _buildActionTile(
                  icon: Icons.cake_outlined,
                  label: 'Date of Birth',
                  value: dob,
                  onTap: () => _showDatePickerDialog(donor?.dob),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _buildActionTile(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight',
                  value: weight,
                  onTap: () => _showNumberInputDialog(
                    title: 'Weight',
                    field: 'weightKg',
                    unit: 'kg',
                    currentValue: donor?.weightKg,
                    min: 40,
                    max: 180,
                  ),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _buildActionTile(
                  icon: Icons.height,
                  label: 'Height',
                  value: height,
                  onTap: () => _showNumberInputDialog(
                    title: 'Height',
                    field: 'heightCm',
                    unit: 'cm',
                    currentValue: donor?.heightCm,
                    min: 120,
                    max: 230,
                  ),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _buildActionTile(
                  icon: Icons.notes_outlined,
                  label: 'Health Notes',
                  value: healthNotes,
                  onTap: () => _showTextEditDialog(
                    title: 'Health Notes',
                    field: 'healthNotes',
                    currentValue: donor?.healthNotes ?? '',
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Section 3: Security & Actions
          const Text(
            'Security',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: const Icon(Icons.lock_outline, color: AppColors.crimson, size: 22),
                  title: const Text('Change Security PIN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                  onTap: _showChangePinDialog,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(auth),
              icon: const Icon(Icons.logout_rounded, color: AppColors.crimson, size: 20),
              label: const Text(
                'Log Out',
                style: TextStyle(color: AppColors.crimson, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.crimson, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: AppColors.crimson, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isHighlight ? AppColors.crimson : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }

  Widget _buildReadOnlyTile({
    required IconData icon,
    required String label,
    required String value,
    bool mono = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Icon(icon, color: AppColors.crimson, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      trailing: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: mono ? AppFonts.mono : AppFonts.sans,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class ChangePinDialog extends StatefulWidget {
  const ChangePinDialog({super.key});

  @override
  State<ChangePinDialog> createState() => _ChangePinDialogState();
}

class _ChangePinDialogState extends State<ChangePinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _changePin() async {
    if (!_formKey.currentState!.validate()) return;
    final newPin = _newPinController.text;
    final confirmPin = _confirmPinController.text;
    if (newPin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match'), backgroundColor: AppColors.crimson),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.changePin(
        _currentPinController.text,
        newPin,
        confirmPin,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
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
                  const Icon(Icons.shield_outlined, color: AppColors.crimson, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Change Security PIN',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
              const Text(
                'Enter your current 4-digit PIN, then choose a new one.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              _pinField('Current PIN', _currentPinController),
              const SizedBox(height: AppSpacing.md),
              _pinField('New PIN', _newPinController),
              const SizedBox(height: AppSpacing.md),
              _pinField('Confirm New PIN', _confirmPinController),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: _isLoading ? null : _changePin,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.crimson,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Update PIN', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          obscuringCharacter: '●',
          maxLength: 4,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: AppFonts.mono),
          inputFormatters: [
            LengthLimitingTextInputFormatter(4),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (v) {
            if (v == null || v.length != 4) return 'PIN must be 4 digits';
            return null;
          },
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.crimson, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}


