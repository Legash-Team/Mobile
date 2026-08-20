import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/bottom_nav_bar.dart';
import 'donor_dashboard_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class DonorHomeShell extends StatefulWidget {
  const DonorHomeShell({super.key});

  @override
  State<DonorHomeShell> createState() => _DonorHomeShellState();
}

class _DonorHomeShellState extends State<DonorHomeShell> {
  int _currentIndex = 0;
  int _pendingCount = 0;

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
            label: 'Profile',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
      ),
    );
  }
}
