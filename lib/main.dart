import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:verleihapp/l10n/app_localizations.dart';
import 'dart:ui';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verleihapp/pages/home.dart';
import 'package:verleihapp/pages/login/pre_login.dart';
import 'package:verleihapp/pages/login/auth_callback.dart';
import 'package:verleihapp/config/supabase_config.dart';
import 'package:verleihapp/components/connectivity_wrapper.dart';

// Supabase Client
final supabase = Supabase.instance.client;
// Global navigator key to allow navigation from auth listeners
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _determineLocale();
    _setupAuthListener();
  }

  void _determineLocale() {
    final List<Locale> systemLocales = PlatformDispatcher.instance.locales;
    
    if (systemLocales.isEmpty) {
      _locale = const Locale('en');
      return;
    }
    
    // First check: if German is the first language, then German
    if (systemLocales.first.languageCode.toLowerCase() == 'de') {
      _locale = const Locale('de');
      return;
    }
    
    // Second check: if English is the first language, then English
    if (systemLocales.first.languageCode.toLowerCase() == 'en') {
      _locale = const Locale('en');
      return;
    }
    
    // Third check: if German is anywhere as an additional language, then German
    for (final locale in systemLocales) {
      if (locale.languageCode.toLowerCase() == 'de') {
        _locale = const Locale('de');
        return;
      }
    }
    
    // Otherwise English as default
    _locale = const Locale('en');
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      setState(() {
        _user = session?.user;
      });

      if (event == AuthChangeEvent.signedOut) {
        setState(() {
          _user = null;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      locale: _locale,
      supportedLocales: const [
        Locale('de'), // German
        Locale('en'), // English
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return ConnectivityWrapper(child: child!);
      },
      home: _user == null ? PreLogin() : const HomePage(),
      navigatorKey: appNavigatorKey,
      routes: {
        '/auth/callback': (_) => const AuthCallbackPage(),
      },
    );
  }

  ThemeData _buildTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.white);
    
    return ThemeData(
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.primary),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
          fontSize: 23,
        ),
        elevation: 0,
      ),
    );
  }
}