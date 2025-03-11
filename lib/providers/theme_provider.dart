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

  // Couleurs de base de la palette
  static const Color primaryOrangeRed = Color(0xFFEB5A3C); // #EB5A3C - Orange-rouge
  static const Color secondaryOrange = Color(0xFFDF9755); // #DF9755 - Orange doré
  static const Color tertiaryGold = Color(0xFFE7D283); // #E7D283 - Jaune doré
  static const Color accentLightYellow = Color(0xFFEDF4C2); // #EDF4C2 - Jaune-vert pâle

  // Thème clair avec la palette personnalisée
  static final _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      // Couleur primaire et dérivés
      primary: primaryOrangeRed,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFFFDAD4), // Version plus claire du rouge-orange
      onPrimaryContainer: const Color(0xFF3E0100), // Rouge foncé pour le texte sur container primaire

      // Couleur secondaire et dérivés
      secondary: secondaryOrange,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFFFDCC1), // Orange pâle pour les containers secondaires
      onSecondaryContainer: const Color(0xFF3F1800), // Orange très foncé pour le texte

      // Couleur tertiaire et dérivés
      tertiary: tertiaryGold,
      onTertiary: const Color(0xFF3F3000), // Brun foncé pour le texte sur fond doré
      tertiaryContainer: const Color(0xFFFFF0C7), // Jaune pâle pour les containers tertiaires
      onTertiaryContainer: const Color(0xFF3F3000), // Brun foncé pour le texte

      // Couleur d'accent
      surface: Colors.white,
      onSurface: const Color(0xFF201A17), // Presque noir avec une touche de chaleur
      surfaceContainerHighest: accentLightYellow.withOpacity(0.7), // Léger jaune-vert pour les variantes
      onSurfaceVariant: const Color(0xFF534340), // Presque noir avec une touche de chaleur

      // Couleurs d'erreur
      error: const Color(0xFFBA1B1B),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDAD4),
      onErrorContainer: const Color(0xFF410001),

      // Autres couleurs utiles
      outline: const Color(0xFF857370), // Brun-gris pour les contours
      shadow: Colors.black.withOpacity(0.1),
      inverseSurface: const Color(0xFF362F2C),
      onInverseSurface: const Color(0xFFF5F0EE),
      inversePrimary: const Color(0xFFFFB4A4),
    ),

    // Style des cartes
    cardTheme: CardTheme(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Style de la barre d'applications
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: accentLightYellow,
      foregroundColor: Color(0xFF201A17),
      iconTheme: IconThemeData(
        color: primaryOrangeRed,
      ),
    ),

    // Style des boutons élevés
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrangeRed,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Style des boutons textes
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrangeRed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),

    // Style des boutons avec contour
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrangeRed,
        side: const BorderSide(color: primaryOrangeRed),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Style des champs de texte
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: accentLightYellow.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryOrangeRed, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: const Color(0xFF201A17).withOpacity(0.5)),
    ),

    // Style des textes
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: Color(0xFF201A17), fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Color(0xFF201A17)),
      bodyMedium: TextStyle(color: Color(0xFF201A17)),
      bodySmall: TextStyle(color: Color(0xFF534340)),
    ),

    // Style du curseur
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryOrangeRed,
      selectionColor: secondaryOrange,
      selectionHandleColor: primaryOrangeRed,
    ),

    // Couleur de fond globale
    scaffoldBackgroundColor: Colors.white,
  );

  // Thème sombre avec la palette personnalisée
  static final _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      // Couleurs primaires et dérivés - versio plus vive pour le mode sombre
      primary: const Color(0xFFFF7A5C), // Version plus vive du primaryOrangeRed
      onPrimary: const Color(0xFF3E0100),
      primaryContainer: const Color(0xFFAD321C), // Version plus foncée, mais encore visible du primaryOrangeRed
      onPrimaryContainer: const Color(0xFFFFDAD4),

      // Couleurs secondaires et dérivés
      secondary: const Color(0xFFF5B577), // Version plus vive du secondaryOrange
      onSecondary: const Color(0xFF3F1800),
      secondaryContainer: const Color(0xFF99602F), // Version plus foncée, mais encore visible du secondaryOrange
      onSecondaryContainer: const Color(0xFFFFDCC1),

      // Couleurs tertiaires et dérivés
      tertiary: const Color(0xFFF7E59C), // Version plus vive du tertiaryGold
      onTertiary: const Color(0xFF3F3000),
      tertiaryContainer: const Color(0xFFAA9850), // Version plus foncée, mais encore visible du tertiaryGold
      onTertiaryContainer: const Color(0xFFFFF0C7),

      // Couleur d'accent adaptée au mode sombre
      surface: const Color(0xFF1A1412),
      onSurface: const Color(0xFFECE0DB),
      surfaceContainerHighest: const Color(0xFF4A4740), // Version sombre du accentLightYellow
      onSurfaceVariant: const Color(0xFFD8C2BE),

      // Couleurs d'erreur
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF930009),
      onErrorContainer: const Color(0xFFFFDAD4),

      // Autres couleurs utiles
      outline: const Color(0xFF9C8783),
      shadow: Colors.black,
      inverseSurface: const Color(0xFFECE0DB),
      onInverseSurface: const Color(0xFF362F2C),
      inversePrimary: const Color(0xFFBF3520),
    ),

    // Style des cartes
    cardTheme: CardTheme(
      elevation: 4,
      color: const Color(0xFF2A211D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Style de la barre d'applications
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF2A211D),
      foregroundColor: Color(0xFFECE0DB),
      iconTheme: IconThemeData(
        color: Color(0xFFFF7A5C), // Version plus vive du primaryOrangeRed
      ),
    ),

    // Style des boutons élevés
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF7A5C), // Version plus vive du primaryOrangeRed
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Style des boutons textes
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFFF7A5C), // Version plus vive du primaryOrangeRed
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    ),

    // Style des boutons avec contour
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFF7A5C), // Version plus vive du primaryOrangeRed
        side: const BorderSide(color: Color(0xFFFF7A5C)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Style des champs de texte
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2F2723),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF7A5C), width: 2), // Version plus vive du primaryOrangeRed
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: const Color(0xFFECE0DB).withOpacity(0.5)),
    ),

    // Style des textes
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: Color(0xFFECE0DB), fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Color(0xFFECE0DB)),
      bodyMedium: TextStyle(color: Color(0xFFECE0DB)),
      bodySmall: TextStyle(color: Color(0xFFD8C2BE)),
    ),

    // Style du curseur
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFFFF7A5C), // Version plus vive du primaryOrangeRed
      selectionColor: Color(0xFFF5B577), // Version plus vive du secondaryOrange
      selectionHandleColor: Color(0xFFFF7A5C),
    ),

    // Couleur de fond globale
    scaffoldBackgroundColor: const Color(0xFF1A1412),
  );
}
