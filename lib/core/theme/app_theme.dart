import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Brand Palette ---
  static const Color primaryColor = Color(0xFF7C5CBF);   // Deep purple-violet
  static const Color secondaryColor = Color(0xFFFF6B9D); // Vibrant coral-pink
  static const Color accentColor = Color(0xFF43D8C9);    // Teal accent
  static const Color warningColor = Color(0xFFFFB547);   // Amber

  // --- Light Theme Colors ---
  static const Color bgLight = Color(0xFFF7F5FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1E1535);
  static const Color subtitleLight = Color(0xFF8B849E);
  static const Color cardShadowColor = Color(0x157C5CBF);

  // --- Dark Theme Colors ---
  static const Color bgDark = Color(0xFF100D1A);
  static const Color surfaceDark = Color(0xFF1C1830);
  static const Color textLight = Color(0xFFF0EEFF);
  static const Color subtitleDark = Color(0xFF8B7FAA);

  // --- Gradient Helpers ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C5CBF), Color(0xFF5B3FA8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF9B72E8), Color(0xFF7C5CBF), Color(0xFF5B3FA8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF7F5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Light Theme ---
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceLight,
        brightness: Brightness.light,
      ).copyWith(surface: surfaceLight),
      scaffoldBackgroundColor: bgLight,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: textDark),
        bodyMedium: GoogleFonts.poppins(color: textDark),
        bodySmall: GoogleFonts.poppins(color: subtitleLight),
        labelLarge: GoogleFonts.poppins(color: surfaceLight, fontWeight: FontWeight.w600),
        labelMedium: GoogleFonts.poppins(color: subtitleLight),
        labelSmall: GoogleFonts.poppins(color: subtitleLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: textDark),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceLight,
        indicatorColor: primaryColor.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              color: primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            );
          }
          return GoogleFonts.poppins(
            color: subtitleLight,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryColor);
          }
          return const IconThemeData(color: subtitleLight);
        }),
        elevation: 8,
        shadowColor: cardShadowColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: cardShadowColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0EEFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(color: subtitleLight, fontSize: 14),
        labelStyle: GoogleFonts.poppins(color: subtitleLight, fontSize: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0EEFF),
        selectedColor: primaryColor.withOpacity(0.2),
        labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        checkmarkColor: primaryColor,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: GoogleFonts.poppins(fontSize: 14),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: surfaceLight,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFEBE8F7),
        thickness: 1,
      ),
    );
  }

  // --- Dark Theme ---
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: const Color(0xFF9B72E8),
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceDark,
        brightness: Brightness.dark,
      ).copyWith(surface: surfaceDark),
      scaffoldBackgroundColor: bgDark,
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        headlineLarge: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: textLight),
        bodyMedium: GoogleFonts.poppins(color: textLight),
        bodySmall: GoogleFonts.poppins(color: subtitleDark),
        labelLarge: GoogleFonts.poppins(color: textLight, fontWeight: FontWeight.w600),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: const Color(0xFF9B72E8).withOpacity(0.25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              color: const Color(0xFF9B72E8),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            );
          }
          return GoogleFonts.poppins(
            color: subtitleDark,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF9B72E8));
          }
          return const IconThemeData(color: subtitleDark);
        }),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF261F3A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF9B72E8), width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(color: subtitleDark, fontSize: 14),
        labelStyle: GoogleFonts.poppins(color: subtitleDark, fontSize: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2344),
        thickness: 1,
      ),
    );
  }
}