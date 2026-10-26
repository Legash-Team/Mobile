import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../models/notification_model.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class DonorNotificationsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToRequests;

  const DonorNotificationsScreen({super.key, this.onNavigateToRequests});

  @override
  State<DonorNotificationsScreen> createState() => _DonorNotificationsScreenState();
}

class _DonorNotificationsScreenState extends State<DonorNotificationsScreen> {
  List<NotificationModel> _items = [];
  bool _loaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await NotificationService.getNotifications();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loaded = true;
        _hasError = false;
      });
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException && e.statusCode == 401) {
        context.read<AuthProvider>().logout();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        return;
      }
      setState(() {
        _loaded = true;
        _hasError = true;
      });
    }
  }

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notifDay = DateTime(date.year, date.month, date.day);

    if (notifDay == today) {
      return 'Today';
    } else if (notifDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final monthName = months[date.month - 1];
      return '$monthName ${date.day}, ${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Map<String, List<NotificationModel>> _groupByDate(List<NotificationModel> list) {
    final Map<String, List<NotificationModel>> groups = {};
    for (final item in list) {
      final header = _getDateHeader(item.notifiedAt);
      groups.putIfAbsent(header, () => []).add(item);
    }
    return groups;
  }

  void _handleTap(NotificationModel item) {
    // Navigate to request if notification points to a blood request
    if (item.type == 'BLOOD_REQUEST' || item.requestId != null) {
      Navigator.pop(context);
      widget.onNavigateToRequests?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(
          l10n?.notifications ?? 'Notifications',
          style: const TextStyle(
            color: AppColors.crimson,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.crimson,
        elevation: 0,
      ),
      body: _buildBody(theme, l10n),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations? l10n) {
    if (!_loaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.crimson),
      );
    }

    if (_hasError) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.xl),
          const Icon(Icons.cloud_off, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n?.couldNotLoadNotifications ?? 'Could not load notifications.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: FilledButton(
              onPressed: _load,
              style: FilledButton.styleFrom(backgroundColor: AppColors.crimson),
              child: Text(l10n?.retry ?? 'Retry'),
            ),
          ),
        ],
      );
    }

    final sorted = List<NotificationModel>.from(_items)
      ..sort((a, b) => b.notifiedAt.compareTo(a.notifiedAt));
    final grouped = _groupByDate(sorted);

    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.crimson,
      child: sorted.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                const Icon(
                  Icons.notifications_none_outlined,
                  size: 56,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n?.noNotificationsYet ?? 'No notifications yet.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              children: [
                for (final entry in grouped.entries) ...[
                  _buildDateHeader(entry.key, l10n),
                  for (final item in entry.value)
                    _buildNotificationTile(item, theme, l10n),
                ],
              ],
            ),
    );
  }

  Widget _buildDateHeader(String title, AppLocalizations? l10n) {
    final displayLabel = title == 'Today'
        ? (l10n?.today ?? 'Today')
        : title == 'Yesterday'
            ? (l10n?.yesterday ?? 'Yesterday')
            : title;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: title == 'Today'
                  ? AppColors.crimson.withValues(alpha: 0.1)
                  : AppColors.paperDim,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: title == 'Today'
                    ? AppColors.crimson.withValues(alpha: 0.3)
                    : AppColors.cardBorder,
              ),
            ),
            child: Text(
              displayLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: title == 'Today' ? AppColors.crimson : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(child: Divider(color: AppColors.cardBorder, height: 1)),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel item, ThemeData theme, AppLocalizations? l10n) {
    final isEmergency = item.isEmergency || item.category == 'Emergency';
    final hasAction = item.type == 'BLOOD_REQUEST' || item.requestId != null;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isEmergency
              ? AppColors.crimson.withValues(alpha: 0.4)
              : AppColors.cardBorder,
          width: isEmergency ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: hasAction ? () => _handleTap(item) : null,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leading Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isEmergency
                        ? AppColors.crimson.withValues(alpha: 0.12)
                        : AppColors.paperDim,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isEmergency
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_outlined,
                    color: isEmergency ? AppColors.crimson : AppColors.textPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Body
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.displayTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isEmergency
                                  ? AppColors.crimson
                                  : AppColors.paperDim,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              item.displayCategory,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isEmergency
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.displayMessage,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(item.notifiedAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (hasAction)
                            Row(
                              children: [
                                Text(
                                  l10n?.viewRequest ?? 'View Request',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.crimson,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 14,
                                  color: AppColors.crimson,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
