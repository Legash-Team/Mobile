import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/profile_info.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _editingField;
  final Map<String, TextEditingController> _editControllers = {};

  ProfileInfo _profile(AuthProvider auth) {
    final donor = auth.donor;
    return ProfileInfo(
      name: donor?.name ?? 'Donor',
      isVerified: true,
      bloodType: donor?.bloodType ?? '',
      phone: donor?.phone ?? '',
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
    if (_editingField != null) {
      setState(() => _editingField = null);
    }
  }

  void _cancelEditing() {
    setState(() => _editingField = null);
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

  Future<void> _showDeleteAccountDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: AppColors.crimson, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 20 / 14),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      leading: Icon(icon, color: AppColors.crimson, size: 22),
      title: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
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
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.crimson)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.crimson, width: 2)),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      leading: Icon(icon, color: AppColors.crimson, size: 22),
      title: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
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
    return const Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md, color: AppColors.cardBorder);
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
          style: TextStyle(color: AppColors.crimson, fontWeight: FontWeight.bold, letterSpacing: 1.5),
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
                  decoration: const BoxDecoration(color: AppColors.crimson, shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.paperDim,
                    child: Text(
                      profile.initials,
                      style: const TextStyle(color: AppColors.crimson, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  profile.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.pillGreen,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, color: AppColors.verified, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Verified Donor',
                        style: TextStyle(color: AppColors.verified, fontSize: 13, fontWeight: FontWeight.w600),
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
                _buildInfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: profile.phone,
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.water_drop_outlined,
                  label: 'Blood Type',
                  field: 'bloodType',
                  value: profile.bloodType.isEmpty ? 'Not set' : profile.bloodType.toUpperCase(),
                  valueWidget: profile.bloodType.isEmpty
                      ? Text(
                          'Enter blood type to receive requests',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.crimson,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            profile.bloodType.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.cake_outlined,
                  label: 'Date of Birth',
                  field: 'dob',
                  value: 'Not set',
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight',
                  field: 'weight',
                  value: 'Not set',
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.height,
                  label: 'Height',
                  field: 'height',
                  value: 'Not set',
                ),
                _buildDivider(),
                _buildInfoTile(
                  icon: Icons.person_outline,
                  label: 'Gender',
                  value: profile.gender,
                ),
                _buildDivider(),
                _buildInfoTile(
                  icon: Icons.badge_outlined,
                  label: 'FIN',
                  value: profile.fin,
                  mono: true,
                ),
                _buildDivider(),
                _buildEditableTile(
                  icon: Icons.favorite_outline,
                  label: 'Health Notes',
                  field: 'healthNotes',
                  value: 'Healthy',
                ),
              ],
            ),
          ),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                  leading: const Icon(Icons.pin_outlined, color: AppColors.crimson, size: 22),
                  title: const Text('Change PIN', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 22),
                  onTap: _showChangePinDialog,
                ),
                _buildDivider(),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
                  leading: const Icon(Icons.delete_outline, color: AppColors.crimson, size: 22),
                  title: const Text('Delete Account', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 22),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(color: AppColors.crimson, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
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
                  const Icon(Icons.pin_outlined, color: AppColors.crimson, size: 24),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Change PIN',
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
              Text(
                'Enter your current PIN, then choose a new one.',
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
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
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Change PIN'),
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
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          obscuringCharacter: '•',
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
      ],
    );
  }
}
