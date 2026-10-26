import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import 'donations_history_screen.dart';
import 'donor_faq_screen.dart';
import 'donor_notifications_screen.dart';
import 'nearby_centers_screen.dart';
import '../models/donor_model.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/blood_compatibility_card.dart';

class DonorDashboardScreen extends StatefulWidget {
  final int pendingCount;
  final VoidCallback? onOpenRequests;

  const DonorDashboardScreen({
    super.key,
    this.pendingCount = 0,
    this.onOpenRequests,
  });

  @override
  State<DonorDashboardScreen> createState() => _DonorDashboardScreenState();
}

class _DonorDashboardScreenState extends State<DonorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    try {
      final res = await AuthService.getProfile();
      if (!mounted) return;
      if (res['success'] == true && res['profile'] != null) {
        final donor = DonorInfo.fromJson(res['profile']);
        Provider.of<AuthProvider>(context, listen: false).updateDonor(donor);
      }
    } catch (_) {}
  }

  String _greeting([AppLocalizations? l10n]) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n?.goodMorning ?? 'Good morning';
    if (hour < 17) return l10n?.goodAfternoon ?? 'Good afternoon';
    return l10n?.goodEvening ?? 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context);
    final donorName = auth.donor?.name ?? 'Donor';
    final bloodType = auth.donor?.bloodType ?? 'unknown';

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
          Badge(
            isLabelVisible: widget.pendingCount > 0,
            backgroundColor: AppColors.crimson,
            textColor: Colors.white,
            label: Text('${widget.pendingCount}'),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonorNotificationsScreen(
                      onNavigateToRequests: widget.onOpenRequests,
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help & FAQ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DonorFaqScreen()),
              );
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        color: AppColors.crimson,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting(l10n)}, $donorName',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  height: 30 / 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n?.eligibleToDonate ?? "You're eligible to donate.",
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: AppSpacing.lg),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.paperDim,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.crimson,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.howLegashWorks ?? 'How Legash works',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n?.howLegashWorksExplanation ??
                                'When a hospital in your area needs blood, you get an alert. '
                                'Accept and the hospital can reach out to you directly.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 20 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.profileTab ?? 'Donor Profile',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.crimson,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            bloodType.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n?.bloodType ?? 'Blood type',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n?.legashMatchExplanation ??
                          'Legash matches you with emergency hospital requests in your area.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              _buildQuickNav(context, l10n),
              const SizedBox(height: AppSpacing.md),

              BloodCompatibilityCard(bloodType: bloodType),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNav(BuildContext context, AppLocalizations? l10n) {
    return Row(
      children: [
        _buildNavChip(
          context,
          icon: Icons.history_outlined,
          label: l10n?.donationHistory ?? 'Donation History',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DonationsHistoryScreen(
                onGoHome: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _buildNavChip(
          context,
          icon: Icons.local_hospital_outlined,
          label: l10n?.nearbyCenters ?? 'Nearby Centers',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NearbyCentersScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildNavChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.crimson.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: AppColors.crimson, size: 22),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DonationsHistoryScreen();
  }
}
