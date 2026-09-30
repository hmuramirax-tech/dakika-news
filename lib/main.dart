import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/router.dart';
import 'package:dakika/config.dart';
import 'package:dakika/services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Initialize AdMob
  await AdService.initialize();

  runApp(const ProviderScope(child: DakikaApp()));
}

class DakikaApp extends StatelessWidget {
  const DakikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DAKIKA',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      routerConfig: appRouter,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final tokens = isDark ? darkTokens : lightTokens;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: tokens.ground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: tokens.accent,
        brightness: brightness,
      ).copyWith(
        surface: tokens.surface,
        primary: tokens.accent,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          color: tokens.ink,
        ),
        headlineLarge: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: tokens.ink,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: tokens.ink,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: tokens.ink,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.04,
          color: tokens.inkSecondary,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: tokens.inkSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.ground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: tokens.surface,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: tokens.surface,
        selectedItemColor: tokens.accent,
        unselectedItemColor: tokens.inkSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
