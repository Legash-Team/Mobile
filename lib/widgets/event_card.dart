import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  decoration: const BoxDecoration(
                    color: AppColors.crimson,
                    shape: BoxShape.circle,
                  ),
                ),
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
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
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
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatDate(event.eventDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.crimson,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.water_drop_outlined,
                        color: AppColors.crimson,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          event.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 20 / 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (event.location != null && event.location!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}