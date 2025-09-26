// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

final class RestaurantSettingsPrefs {
  // Singleton pattern
  static final RestaurantSettingsPrefs _instance = RestaurantSettingsPrefs._internal();

  RestaurantSettingsPrefs._internal();

  factory RestaurantSettingsPrefs() => _instance;

  SharedPreferencesAsync? _prefs;

  SharedPreferencesAsync get prefs => _prefs ??= SharedPreferencesAsync();

  static const String _kIsDailyReminderActived = 'is_daily_reminder';
  static const String _kIsDarkModeActived = 'is_dark_mode';

  Future<void> setIsDailyReminderActived(bool value) async {
    return await prefs.setBool(_kIsDailyReminderActived, value);
  }

  Future<bool> getIsDailyReminderActived() async {
    return await prefs.getBool(_kIsDailyReminderActived) ?? false; // default: false
  }

  Future<void> setIsDarkModeActived(bool value) async {
    return await prefs.setBool(_kIsDarkModeActived, value);
  }

  Future<bool> getIsDarkModeActived() async {
    return await prefs.getBool(_kIsDarkModeActived) ?? false; // default: false
  }
}
