import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/notification_model.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  final ValueChanged<int>? onPendingCountChanged;

  const NotificationsScreen({super.key, this.onPendingCountChanged});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _filters = ['Ongoing', 'Accepted', 'Denied'];

  List<NotificationModel> _items = [];
  bool _loaded = false;
  bool _hasError = false;
  String _activeFilter = 'Ongoing';

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
      _reportPending(items);
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException && e.statusCode == 401) {
        context.read<AuthProvider>().logout();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        return;
      }
      if (e is ApiException && e.statusCode == 404) {
        setState(() {
          _items = [];
          _loaded = true;
          _hasError = false;
        });
        _reportPending(const []);
        return;
      }
      setState(() {
        _loaded = true;
        _hasError = true;
      });
    }
  }

  void _reportPending(List<NotificationModel> items) {
    final count = items.where((n) => n.isPending && n.isOpen).length;
    widget.onPendingCountChanged?.call(count);
  }

  List<NotificationModel> get _visible {
    switch (_activeFilter) {
      case 'Accepted':
        return _items.where((n) => n.isAccepted).toList();
      case 'Denied':
        return _items.where((n) => n.isDenied).toList();
      case 'Ongoing':
      default:
        return _items.where((n) => n.isPending).toList();
    }
  }

  void _onCardChanged(NotificationModel updated) {
    setState(() {
      _items = [
        for (final item in _items) item.id == updated.id ? updated : item,
      ];
    });
    _reportPending(_items);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: const Text(
          'Requests',
          style: TextStyle(
            color: AppColors.crimson,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.paper,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                for (final filter in _filters) ...[
                  if (filter != _filters.first) const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _activeFilter == filter
                              ? AppColors.crimson
                              : AppColors.paperDim,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: _activeFilter == filter
                                ? AppColors.crimson
                                : AppColors.cardBorder.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              filter,
                              style: TextStyle(
                                color: _activeFilter == filter
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _activeFilter == filter
                                    ? Colors.white.withOpacity(0.25)
                                    : AppColors.cardBorder,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                '${_getCountForFilter(filter)}',
                                style: TextStyle(
                                  color: _activeFilter == filter
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(child: _buildBody(theme)),
        ],
      ),
    );
  }

  int _getCountForFilter(String filter) {
    switch (filter) {
      case 'Accepted':
        return _items.where((n) => n.isAccepted).length;
      case 'Denied':
        return _items.where((n) => n.isDenied).length;
      case 'Ongoing':
      default:
        return _items.where((n) => n.isPending).length;
    }
  }

  Widget _buildBody(ThemeData theme) {
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
            'Could not load requests.',
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
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    final visible = _visible;
    return RefreshIndicator(
      onRefresh: _load,
      color: AppColors.crimson,
      child: visible.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                const Icon(
                  Icons.campaign_outlined,
                  size: 56,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No $_activeFilter requests.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
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
                for (final item in visible)
                  NotificationCard(
                    notification: item,
                    onChanged: _onCardChanged,
                  ),
              ],
            ),
    );
  }
}
