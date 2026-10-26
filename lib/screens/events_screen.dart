import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  static const _filters = ['Active', 'Closed'];
  String _activeFilter = 'Active';

  List<EventModel>? _events;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final events = await EventService.getEvents(status: 'all');
      if (!mounted) return;
      setState(() => _events = events);
    } catch (e) {
      debugPrint('[EventsScreen] Failed to load events: $e');
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  List<EventModel> get _visibleEvents {
    final events = _events ?? [];
    if (_activeFilter == 'Closed') {
      return events.where((e) => !e.isOpen).toList();
    }
    return events.where((e) => e.isOpen).toList();
  }

  int _getCountForFilter(String filter) {
    final events = _events ?? [];
    if (filter == 'Closed') {
      return events.where((e) => !e.isOpen).length;
    }
    return events.where((e) => e.isOpen).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(
          l10n?.eventsTab ?? 'Events',
          style: const TextStyle(
            color: AppColors.crimson,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Tabs (following notifications / requests segmented pill navigation)
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
                                : AppColors.cardBorder.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              filter == 'Active'
                                  ? (l10n?.activeTab ?? 'Active')
                                  : (l10n?.closedTab ?? 'Closed'),
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
                                    ? Colors.white.withValues(alpha: 0.25)
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
          Expanded(
            child: RefreshIndicator(
              onRefresh: _load,
              color: AppColors.crimson,
              child: _buildBody(theme, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations? l10n) {
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.xl),
          const Icon(Icons.cloud_off, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n?.couldNotLoadEvents ?? 'Could not load events.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          if (_error != null && kDebugMode) ...[
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.crimson,
                  fontSize: 12,
                ),
              ),
            ),
          ],
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

    final events = _events;
    if (events == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.crimson),
      );
    }

    final visible = _visibleEvents;
    if (visible.isEmpty) {
      final emptyText = _activeFilter == 'Active'
          ? (l10n?.noActiveEvents ?? 'No active events at this time.')
          : (l10n?.noClosedEvents ?? 'No closed events.');

      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.event_note_outlined, size: 56, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            emptyText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      children: [
        for (final event in visible) EventCard(event: event),
      ],
    );
  }
}