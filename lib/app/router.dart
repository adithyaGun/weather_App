import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/forecast/presentation/forecast_screen.dart';
import '../features/favourites/presentation/favourite_screen.dart';
import '../features/settings/presentation/setting_screen.dart';



final router = GoRouter(
  initialLocation: '/',
  routes: [
    
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/forecast',
          name: 'forecast',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ForecastScreen(),
          ),
        ),
        GoRoute(
          path: '/favourites',
          name: 'favourites',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FavoritesScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: _buildModernBottomNav(context),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/forecast');
        break;
      case 2:
        context.go('/favourites');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  Widget _buildModernBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E2E)
            : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
          _buildNavItem(1, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Forecast'),
          _buildNavItem(2, Icons.favorite_rounded, Icons.favorite_outline_rounded, 'Favorites'),
          _buildNavItem(3, Icons.settings_rounded, Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected 
        ? Theme.of(context).primaryColor 
        : Colors.grey;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: color,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
