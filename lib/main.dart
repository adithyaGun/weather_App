import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'core/theme/app_theme.dart';
import 'data/service/local_storage_service.dart';
import 'features/settings/presentation/setting_provider.dart';



void main() async {
  // Ensure Flutter is initialized before running async code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage service
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  
  // Run the app with ProviderScope (Riverpod)
  runApp(
    const ProviderScope(
      child: WeatherApp(),
    ),
  );
}


class WeatherApp extends ConsumerStatefulWidget {
  const WeatherApp({super.key});

  @override
  ConsumerState<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends ConsumerState<WeatherApp> {
  @override
  void initState() {
    super.initState();
    // Load settings on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);

    return MaterialApp.router(
      // App title
      title: 'Weather App',
      
      // Hide debug banner
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsState.isDarkTheme 
          ? ThemeMode.dark 
          : ThemeMode.light,
      
      // GoRouter configuration
      routerConfig: router,
    );
  }
}
