import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/appliance_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/language_controller.dart';
import 'services/protected_status_service.dart';
import 'services/tariff_service.dart';
import 'services/theme_controller.dart';

ThemeData _buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF9A825),
      brightness: brightness,
    ),
    scaffoldBackgroundColor: dark
        ? const Color(0xFF121212)
        : const Color(0xFFF7F7F9),
    cardTheme: CardThemeData(
      elevation: 0,
      color: dark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplianceProvider()),
        ChangeNotifierProvider(create: (_) => TariffService()),
        ChangeNotifierProvider(create: (_) => ProtectedStatusService()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => LanguageController()),
      ],
      child: Consumer2<ThemeController, LanguageController>(
        builder: (context, themeController, lang, _) => MaterialApp(
          // New key on language change rebuilds every screen with new text
          key: ValueKey(LanguageController.isUrdu),
          debugShowCheckedModeBanner: false,
          title: 'WattWise',
          locale: lang.locale,
          supportedLocales: const [Locale('en'), Locale('ur')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: themeController.mode,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return snap.hasData ? const HomeScreen() : const LoginScreen();
            },
          ),
        ),
      ),
    ),
  );
}
