import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  int _profileRefreshKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          ProfileScreen(key: ValueKey(_profileRefreshKey)),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
                if (index == 1) _profileRefreshKey++;
              });
            },
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFB2F7EF),
            surfaceTintColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 400),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.checklist_outlined, color: Color(0xFF00695C)),
                selectedIcon: Icon(Icons.checklist, color: Color(0xFF004D40)),
                label: 'Tasks',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: Color(0xFF00695C)),
                selectedIcon: Icon(Icons.person, color: Color(0xFF004D40)),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

