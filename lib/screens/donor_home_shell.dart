import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/bottom_nav_bar.dart';
import 'donor_dashboard_screen.dart';
import 'events_screen.dart';
import 'notifications_screen.dart';

class DonorHomeShell extends StatefulWidget {
  const DonorHomeShell({super.key});

  @override
  State<DonorHomeShell> createState() => _DonorHomeShellState();
}

class _DonorHomeShellState extends State<DonorHomeShell> {
  int _currentIndex = 0;
  int _pendingCount = 0;

  void _openRequests() {
    setState(() => _currentIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DonorDashboardScreen(onOpenRequests: _openRequests),
          const EventsScreen(),
          NotificationsScreen(
            onPendingCountChanged: (count) {
              if (count != _pendingCount) {
                setState(() => _pendingCount = count);
              }
            },
          ),
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
          const BottomNavItem(
            label: 'Events',
            icon: Icons.event_note_outlined,
            activeIcon: Icons.event_note,
          ),
          BottomNavItem(
            label: 'Requests',
            icon: Icons.campaign_outlined,
            activeIcon: Icons.campaign,
            pendingCount: _pendingCount,
          ),
        ],
      ),
    );
  }
}