import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'setting_provider.dart';
import '../../favourites/presentation/favourite_provider.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final favoritesState = ref.watch(favoritesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Minimal Header
              _buildHeader(context, isDark),
              
              const SizedBox(height: 24),
              
              // Display Settings Section
              _buildSectionHeader(context, 'Display', isDark),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context: context,
                isDark: isDark,
                children: [
                  _buildModernSettingsTile(
                    context: context,
                    isDark: isDark,
                    icon: settingsState.isDarkTheme ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    iconColor: settingsState.isDarkTheme ? Colors.indigo : Colors.amber,
                    title: 'Dark Theme',
                    subtitle: settingsState.themeLabel,
                    trailing: _buildModernSwitch(
                      context: context,
                      value: settingsState.isDarkTheme,
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).setTheme(value);
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Units Settings Section
              _buildSectionHeader(context, 'Units', isDark),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context: context,
                isDark: isDark,
                children: [
                  _buildModernSettingsTile(
                    context: context,
                    isDark: isDark,
                    icon: Icons.thermostat_rounded,
                    iconColor: Colors.orange,
                    title: 'Temperature Unit',
                    subtitle: settingsState.temperatureUnitLabel,
                    trailing: _buildModernSwitch(
                      context: context,
                      value: settingsState.isCelsius,
                      onChanged: (value) {
                        ref.read(settingsProvider.notifier).setTemperatureUnit(value);
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Data Settings Section
              _buildSectionHeader(context, 'Data', isDark),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context: context,
                isDark: isDark,
                children: [
                  _buildModernSettingsTile(
                    context: context,
                    isDark: isDark,
                    icon: Icons.delete_outline_rounded,
                    iconColor: Colors.red,
                    title: 'Clear All Favorites',
                    subtitle: '${favoritesState.favoritesCount} cities saved',
                    onTap: () => _showClearFavoritesDialog(context, ref, favoritesState.favoritesCount),
                    showArrow: true,
                  ),
                  _buildDivider(isDark),
                  _buildModernSettingsTile(
                    context: context,
                    isDark: isDark,
                    icon: Icons.refresh_rounded,
                    iconColor: Colors.blue,
                    title: 'Reset Settings',
                    subtitle: 'Restore default settings',
                    onTap: () => _showResetSettingsDialog(context, ref),
                    showArrow: true,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // About Section
              _buildSectionHeader(context, 'About', isDark),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context: context,
                isDark: isDark,
                children: [
                  _buildModernSettingsTile(
                    context: context,
                    isDark: isDark,
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.teal,
                    title: 'Weather App',
                    subtitle: 'Version 1.0.0',
                  ),
                  _buildDivider(isDark),
                  _buildModernSettingsTile(
                    context: context,
                    isDark: isDark,
                    icon: Icons.cloud_outlined,
                    iconColor: Colors.lightBlue,
                    title: 'Weather Data',
                    subtitle: 'Powered by OpenWeatherMap',
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.settings_rounded,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Customize your experience',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required BuildContext context, required bool isDark, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.grey.withValues(alpha: 0.12),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 1,
        color: isDark 
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.15),
      ),
    );
  }

  Widget _buildModernSettingsTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showArrow = false,
  }) {
    final textColor = isDark ? Colors.white : Colors.grey[800];
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              if (showArrow)
                Icon(
                  Icons.chevron_right_rounded,
                  color: subtitleColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernSwitch({
    required BuildContext context,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
    );
  }

  void _showClearFavoritesDialog(BuildContext context, WidgetRef ref, int count) {
    if (count == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Text('No favorites to clear'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Clear Favorites'),
          ],
        ),
        content: const Text('Are you sure you want to remove all favorite cities? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(favoritesProvider.notifier).clearAllFavorites();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      const Text('All favorites cleared'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showResetSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.refresh_rounded, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Reset Settings'),
          ],
        ),
        content: const Text('Are you sure you want to reset all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(settingsProvider.notifier).resetSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      const Text('Settings reset to default'),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
