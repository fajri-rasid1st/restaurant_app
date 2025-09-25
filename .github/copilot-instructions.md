# AI Agent Instructions for Restaurant App

This is a Flutter mobile application for displaying restaurant information. The app follows specific architectural patterns and conventions that you should be aware of when making changes.

## Project Architecture

### Directory Structure

- `/lib`
  - `app.dart` - Main app configuration and theme setup
  - `models/` - Data models (Restaurant, RestaurantDetail, RestaurantFavorite)
  - `providers/` - State management using Provider pattern
    - `api_providers/` - API service providers
    - `app_providers/` - Application state providers
    - `database_providers/` - Local database providers
    - `prefs_providers/` - SharedPreferences providers
  - `services/` - Business logic and service implementations
  - `ui/` - UI components and screens
  - `common/` - Shared utilities, constants, themes, and extensions

### Key Patterns

1. **State Management**

   - Uses Provider pattern for state management
   - Example in `lib/app.dart`:

   ```dart
   final isDark = context.select<IsDarkModeActivedProvider, bool>((provider) => provider.value);
   ```

2. **Data Models**

   - Models use factory constructors for JSON parsing
   - Models implement copyWith pattern for immutability
   - Example in `lib/models/restaurant.dart`

3. **Local Storage**

   - Uses SQLite (sqflite) for favorite restaurants
   - SharedPreferences for app settings
   - See `database_providers/` and `prefs_providers/`

4. **Asset Management**
   - Images in `assets/images/`
   - Icons in `assets/icons/`
   - Vector graphics in `assets/vectors/`

## Development Workflow

### Required Tools

- Flutter SDK ^3.9.2
- Dependencies managed through `pubspec.yaml`

### Common Tasks

1. **Running the App**

   ```bash
   flutter pub get
   flutter run
   ```

2. **Asset Generation**

   - App icons and splash screen are auto-generated using:
     - `flutter_launcher_icons.yaml`
     - `flutter_native_splash.yaml`

3. **Adding New Features**
   - Create models in `models/`
   - Implement providers in appropriate provider directory
   - Add UI components in `ui/`
   - Register providers in widget tree

## External Dependencies

Key packages:

- `provider` - State management
- `http` - Network requests
- `sqflite` - Local database
- `shared_preferences` - Key-value storage
- `cached_network_image` - Image caching
- `flutter_svg` - SVG rendering

## Error Handling Conventions

- API errors handled in api_providers
- Database errors handled in database_providers
- UI should display appropriate error states using error widgets

## Style Conventions

- Follows standard Flutter/Dart style guide
- Uses region comments to organize large files
- Indonesian language comments for documentation
