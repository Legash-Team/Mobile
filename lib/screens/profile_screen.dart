import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/profile_info.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _sensitiveRevealed = false;
  String? _editingField;

  final Map<String, TextEditingController> _editControllers = {};

  ProfileInfo _profile(AuthProvider auth) {
    final donor = auth.donor;
    return ProfileInfo(
      name: donor?.name ?? 'Abebe Kebede',
      isVerified: true,
      bloodType: donor?.bloodType ?? 'B+',
      phone: donor?.phone ?? '+251 912 345 678',
      fin: 'ETH-8829-1029-4401',
      gender: 'Male',
      location: 'Addis Ababa',
      searchRadiusKm: 4,
    );
  }

  TextEditingController _controllerFor(String field, String value) {
    return _editControllers.putIfAbsent(field, () => TextEditingController(text: value));
  }

  void _startEditing(String field, String currentValue) {
    setState(() {
      _editingField = field;
      _controllerFor(field, currentValue);
    });
  }

  void _saveEditing(String field) {
    final controller = _editControllers[field];
    if (controller != null && controller.text.trim().isNotEmpty) {
      setState(() => _editingField = null);
    }
  }

  void _cancelEditing() {
    setState(() => _editingField = null);
  }

  Future<void> _showPasswordDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        title: const Text(
          'Verify Identity',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.paperDim,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(color: AppColors.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(color: AppColors.crimson),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.crimson,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: const Text('Verify'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    controller.dispose();

    if (result == true) {
      setState(() => _sensitiveRevealed = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sensitive fields are now visible.'),
          backgroundColor: AppColors.verified,
        ),
      );
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: AppColors.crimson,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 20 / 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.crimson,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deletion is not yet implemented.'),
          backgroundColor: AppColors.crimson,
        ),
      );
    }
  }

  Widget _buildEditableTile({
    required IconData icon,
    required String label,
    required String field,
    required String value,
    bool mono = false,
    Widget? valueWidget,
    VoidCallback? onTap,
  }) {
    final isEditing = _editingField == field;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      leading: Icon(icon, color: AppColors.crimson, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: isEditing
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _controllerFor(field, value),
                    autofocus: true,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: mono ? AppFonts.mono : AppFonts.sans,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.crimson),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.crimson, width: 2),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle, color: AppColors.crimson, size: 22),
                  onPressed: () => _saveEditing(field),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: AppColors.textSecondary, size: 20),
                  onPressed: _cancelEditing,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            )
          : GestureDetector(
              onTap: onTap ?? () => _startEditing(field, value),
              child: valueWidget ??
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: mono ? AppFonts.mono : AppFonts.sans,
                    ),
                  ),
            ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    bool mono = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      leading: Icon(icon, color: AppColors.crimson, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: Text(
        value,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: mono ? AppFonts.mono : AppFonts.sans,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: AppSpacing.md,
      endIndent: AppSpacing.md,
      color: AppColors.cardBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final profile = _profile(auth);

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text(
          'LEGASH',
          style: TextStyle(
            color: AppColors.crimson,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.crimson,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: const BoxDecoration(
                    color: AppColors.crimson,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.paperDim,
                    child: Text(
                      profile.initials,
                      style: const TextStyle(
                        color: AppColors.crimson,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onTap: () => _startEditing('name', profile.name),
                  child: Text(
                    _editingField == 'name'
                        ? (_editControllers['name']?.text ?? profile.name)
                        : profile.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillGreen,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        color: AppColors.verified,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Verified Donor',
                        style: TextStyle(
                          color: AppColors.verified,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Account details',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.paperDim,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                _buildEditableTile(
                  icon: Icons.person_outline,
                  label: 'Name',
                  field: 'name',
                  value: profile.name,
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  field: 'phone',
                  value: profile.phone,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Phone number can only be changed via OTP verification. Please contact support.',
                        ),
                        backgroundColor: AppColors.crimson,
                      ),
                    );
                  },
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.water_drop_outlined,
                  label: 'Blood Type',
                  field: 'bloodType',
                  value: profile.bloodType.toUpperCase(),
                  valueWidget: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.crimson,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      profile.bloodType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.cake_outlined,
                  label: 'Date of Birth',
                  field: 'dob',
                  value: '1995-06-15',
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight',
                  field: 'weight',
                  value: '72 kg',
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.height,
                  label: 'Height',
                  field: 'height',
                  value: '175 cm',
                ),
                _buildDivider(),
                _buildInfoTile(
                  icon: Icons.person_outline,
                  label: 'Gender',
                  value: profile.gender,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (!_sensitiveRevealed)
            GestureDetector(
              onTap: _showPasswordDialog,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.paperDim,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, color: AppColors.crimson, size: 18),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Enter password to view sensitive fields',
                      style: TextStyle(
                        color: AppColors.crimson,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_sensitiveRevealed) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sensitive Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pillGreen,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_open, color: AppColors.verified, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Revealed',
                        style: TextStyle(
                          color: AppColors.verified,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.paperDim,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.badge_outlined,
                    label: 'FIN',
                    value: profile.fin,
                    mono: true,
                  ),
                  _buildDivider(),
                  _buildInfoTile(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Weight',
                    value: '72 kg',
                  ),
                  _buildDivider(),
                  _buildInfoTile(
                    icon: Icons.height,
                    label: 'Height',
                    value: '175 cm',
                  ),
                  _buildDivider(),
                  _buildInfoTile(
                    icon: Icons.favorite_outline,
                    label: 'Health Condition',
                    value: 'Healthy',
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),
          Text(
            'Security',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: AppColors.paperDim,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 4,
                  ),
                  leading: const Icon(Icons.lock_outline, color: AppColors.crimson, size: 22),
                  title: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Change password functionality coming soon.'),
                        backgroundColor: AppColors.crimson,
                      ),
                    );
                  },
                ),
                _buildDivider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 4,
                  ),
                  leading: const Icon(Icons.delete_outline, color: AppColors.crimson, size: 22),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                auth.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.crimson),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: AppColors.crimson,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
