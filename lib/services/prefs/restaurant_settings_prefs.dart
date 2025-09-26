// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

const String kDarkModeKey = 'dark_mode';
const String kDailyReminderKey = 'daily_reminder';
const String kRestaurantRecommendationKey = 'restaurant_recommendation';

final class RestaurantSettingsPrefs {
  // Singleton pattern
  static final RestaurantSettingsPrefs _instance = RestaurantSettingsPrefs._internal();

  RestaurantSettingsPrefs._internal();

  factory RestaurantSettingsPrefs() => _instance;

  SharedPreferencesAsync? _prefs;

  SharedPreferencesAsync get prefs => _prefs ??= SharedPreferencesAsync();

  Future<void> setValue(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  Future<bool> getValue(String key) async {
    return await prefs.getBool(key) ?? false; // default: false
  }
}
