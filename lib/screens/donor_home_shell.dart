import 'package:flutter/material.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../widgets/bottom_nav_bar.dart';
import 'donor_dashboard_screen.dart';
import 'events_screen.dart';
import 'feed_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class DonorHomeShell extends StatefulWidget {
  final int initialTab;
  final String? requestId;

  const DonorHomeShell({super.key, this.initialTab = 0, this.requestId});

  @override
  State<DonorHomeShell> createState() => _DonorHomeShellState();
}

class _DonorHomeShellState extends State<DonorHomeShell> {
  late int _currentIndex;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _openRequests() {
    setState(() => _currentIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DonorDashboardScreen(
            pendingCount: _pendingCount,
            onOpenRequests: _openRequests,
          ),
          NotificationsScreen(
            onPendingCountChanged: (count) {
              if (count != _pendingCount) {
                setState(() => _pendingCount = count);
              }
            },
          ),
          const FeedScreen(),
          const EventsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavItem(
            label: l10n?.homeTab ?? 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          BottomNavItem(
            label: l10n?.requestsTab ?? 'Requests',
            icon: Icons.campaign_outlined,
            activeIcon: Icons.campaign,
            pendingCount: _pendingCount,
          ),
          BottomNavItem(
            label: l10n?.feedTab ?? 'Feed',
            icon: Icons.dynamic_feed_outlined,
            activeIcon: Icons.dynamic_feed,
          ),
          BottomNavItem(
            label: l10n?.eventsTab ?? 'Events',
            icon: Icons.event_note_outlined,
            activeIcon: Icons.event_note,
          ),
          BottomNavItem(
            label: l10n?.profileTab ?? 'Profile',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
      ),
    );
  }
}
