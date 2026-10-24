import 'package:flutter/material.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../models/donation_record.dart';
import '../services/donation_service.dart';

class DonationsHistoryScreen extends StatefulWidget {
  final VoidCallback? onGoHome;

  const DonationsHistoryScreen({super.key, this.onGoHome});

  @override
  State<DonationsHistoryScreen> createState() => _DonationsHistoryScreenState();
}

class _DonationsHistoryScreenState extends State<DonationsHistoryScreen> {
  List<DonationRecord> _donations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final donations = await DonationService.getDonationHistory();
      if (!mounted) return;
      setState(() {
        _donations = donations..sort(
              (a, b) => b.donatedAt.compareTo(a.donatedAt),
            );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Home',
          onPressed: widget.onGoHome ?? () => Navigator.pop(context),
        ),
        title: const Text(
          'Donation History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.paper,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.crimson,
        child: _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations? l10n) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.crimson),
      );
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: 80),
          const Icon(Icons.error_outline, size: 48, color: AppColors.crimson),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Could not load donation history.',
            textAlign: TextAlign.center,
            style: themeText(context).bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: FilledButton(
              onPressed: _load,
              style: FilledButton.styleFrom(backgroundColor: AppColors.crimson),
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (_donations.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: 80),
          const Icon(Icons.history_outlined, size: 56, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No donation history yet',
            textAlign: TextAlign.center,
            style: themeText(context).titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Your past blood donation records will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _donations.length,
      itemBuilder: (context, index) {
        final donation = _donations[index];
        return _buildDonationCard(donation, l10n);
      },
    );
  }

  TextTheme themeText(BuildContext context) => Theme.of(context).textTheme;

  Widget _buildDonationCard(DonationRecord d, [AppLocalizations? l10n]) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.crimson.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.bloodtype,
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
                      d.centerName,
                      style: themeText(context).titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      d.centerAddress ?? 'Blood Center',
                      style: themeText(context).bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: d.isCompleted
                      ? AppColors.pillGreen
                      : AppColors.sand.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  d.status[0].toUpperCase() + d.status.substring(1),
                  style: const TextStyle(
                    color: AppColors.verified,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildDetailItem(Icons.water_drop, 'Blood Type', d.bloodType),
              const SizedBox(width: AppSpacing.lg),
              _buildDetailItem(Icons.schedule, 'Date', d.formattedDate),
              const SizedBox(width: AppSpacing.lg),
              _buildDetailItem(
                  Icons.local_drink, 'Quantity', d.formattedQuantity),
            ],
          ),
          if (d.note != null && d.note!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.paperDim,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                d.note!,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
