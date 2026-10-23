import 'package:flutter/material.dart';
import '../constants.dart';
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
          const BottomNavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          BottomNavItem(
            label: 'Requests',
            icon: Icons.campaign_outlined,
            activeIcon: Icons.campaign,
            pendingCount: _pendingCount,
          ),
          const BottomNavItem(
            label: 'Feed',
            icon: Icons.dynamic_feed_outlined,
            activeIcon: Icons.dynamic_feed,
          ),
          const BottomNavItem(
            label: 'Events',
            icon: Icons.event_note_outlined,
            activeIcon: Icons.event_note,
          ),
          const BottomNavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
      ),
    );
  }
}
