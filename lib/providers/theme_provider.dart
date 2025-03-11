import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String themeBox = 'theme_box';
  static const String themeKey = 'is_dark_mode';

  late Box _box;
  bool _isDarkMode = false;

  ThemeProvider() {
    _initializeTheme();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _initializeTheme() async {
    _box = await Hive.openBox(themeBox);
    _isDarkMode = _box.get(themeKey, defaultValue: false);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _box.put(themeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  // Light theme with enhanced colors
  static final _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF6750A4), // Deep purple
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFEADDFF), // Light purple for containers
      onPrimaryContainer: const Color(0xFF21005E), // Dark purple for text on containers

      secondary: const Color(0xFF7F67BE), // Medium purple
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE8DEF8), // Very light purple for secondary containers
      onSecondaryContainer: const Color(0xFF1D192B), // Very dark purple for text on secondary containers

      tertiary: const Color(0xFF2196F3), // Blue
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFD4E3FF), // Light blue container
      onTertiaryContainer: const Color(0xFF001D36), // Dark blue text

      error: const Color(0xFFBA1A1A), // Error red
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD6), // Light error container
      onErrorContainer: const Color(0xFF410002), // Very dark text

      surface: const Color(0xFFFFFBFE), // Surface color
      onSurface: const Color(0xFF1C1B1F), // Text on surface

      surfaceContainerHighest: const Color(0xFFE7E0EC), // Alternate surface color
      onSurfaceVariant: const Color(0xFF49454F), // Text on alternate surface

      outline: const Color(0xFF79747E), // Border outline color
      shadow: const Color(0xFF000000), // Shadow color

      inverseSurface: const Color(0xFF313033), // Inverse of surface for contrast
      onInverseSurface: const Color(0xFFF4EFF4), // Inverse of onSurface
      inversePrimary: const Color(0xFFD0BCFF), // Inverse of primary
    ),

    // Card theme
    cardTheme: const CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // App bar theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFFF6EFFE),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F2FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCAC4D0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCAC4D0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6750A4), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Text themes
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F)),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F)),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1C1B1F)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1C1B1F)),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1C1B1F)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1C1B1F)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF1C1B1F)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF49454F)),
    ),
  );

  // Dark theme with enhanced colors
  static final _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFD0BCFF), // Light purple primary
      onPrimary: const Color(0xFF381E72), // Dark purple for text on primary
      primaryContainer: const Color(0xFF4F378B), // Medium-dark purple for containers
      onPrimaryContainer: const Color(0xFFEADDFF), // Light purple for text on containers

      secondary: const Color(0xFFCCC2DC), // Light purple-gray secondary
      onSecondary: const Color(0xFF332D41), // Dark purple-gray for text on secondary
      secondaryContainer: const Color(0xFF4A4458), // Darker purple-gray container
      onSecondaryContainer: const Color(0xFFE8DEF8), // Light purple-gray text

      tertiary: const Color(0xFF82B1FF), // Light blue tertiary
      onTertiary: const Color(0xFF00325A), // Very dark blue for text on tertiary
      tertiaryContainer: const Color(0xFF0B57A0), // Medium-dark blue container
      onTertiaryContainer: const Color(0xFFD4E3FF), // Light blue text

      error: const Color(0xFFFFB4AB), // Light red error
      onError: const Color(0xFF690005), // Dark red text
      errorContainer: const Color(0xFF93000A), // Medium-dark red container
      onErrorContainer: const Color(0xFFFFDAD6), // Light text on background

      surface: const Color(0xFF1C1B1F), // Very dark surface
      onSurface: const Color(0xFFE6E1E5), // Light text on surface

      surfaceContainerHighest: const Color(0xFF49454F), // Alternate surface color
      onSurfaceVariant: const Color(0xFFCAC4D0), // Text on alternate surface

      outline: const Color(0xFF938F99), // Border outline color
      shadow: const Color(0xFF000000), // Shadow color

      inverseSurface: const Color(0xFFE6E1E5), // Inverse of surface
      onInverseSurface: const Color(0xFF313033), // Inverse of onSurface
      inversePrimary: const Color(0xFF6750A4), // Inverse of primary
    ),

    // Card theme
    cardTheme: const CardTheme(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),

    // App bar theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF2B2930),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2B2930),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF49454F)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF49454F)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD0BCFF), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Text themes
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFE6E1E5)),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE6E1E5)),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE6E1E5)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFE6E1E5)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFE6E1E5)),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFE6E1E5)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE6E1E5)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFE6E1E5)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFFCAC4D0)),
    ),
  );
}
