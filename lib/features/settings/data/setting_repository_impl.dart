import '../../../data/service/local_storage_service.dart';
import '../domain/settings_repository.dart';


class SettingsRepositoryImpl implements SettingsRepository {
  final LocalStorageService _storageService;

  SettingsRepositoryImpl(this._storageService);

  @override
  Future<bool> getIsDarkTheme() async {
    return await _storageService.getTheme();
  }

  @override
  Future<void> setIsDarkTheme(bool isDark) async {
    await _storageService.setTheme(isDark);
  }

  @override
  Future<bool> getIsCelsius() async {
    return await _storageService.getTemperatureUnit();
  }

  @override
  Future<void> setIsCelsius(bool isCelsius) async {
    await _storageService.setTemperatureUnit(isCelsius);
  }

  @override
  Future<({bool isDarkTheme, bool isCelsius})> loadSettings() async {
    final isDarkTheme = await getIsDarkTheme();
    final isCelsius = await getIsCelsius();
    return (isDarkTheme: isDarkTheme, isCelsius: isCelsius);
  }

  @override
  Future<void> resetSettings() async {
    await setIsDarkTheme(false);
    await setIsCelsius(true);
  }
}
