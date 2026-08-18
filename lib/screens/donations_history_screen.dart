import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/donation_model.dart';

class DonationsHistoryScreen extends StatelessWidget {
  final VoidCallback? onGoHome;

  const DonationsHistoryScreen({super.key, this.onGoHome});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Home',
          onPressed: onGoHome,
        ),
        title: const Text(
          'My Impact',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.paperDim,
              child: Icon(
                Icons.person,
                color: AppColors.crimson,
                size: 20,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.paper,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              'History',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (final (index, donation) in mockDonations.indexed)
            _buildTimelineItem(theme, donation, isLatest: index == 0),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    ThemeData theme,
    DonationModel donation, {
    required bool isLatest,
  }) {
    final isLast = mockDonations.last == donation;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isLatest ? AppColors.crimson : AppColors.paperDim,
                    shape: BoxShape.circle,
                    border: isLatest
                        ? null
                        : Border.all(color: AppColors.cardBorder),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.cardBorder,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.hospitalName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(donation.date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(
                        Icons.water_drop_outlined,
                        color: AppColors.crimson,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        donation.formattedAmount,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}