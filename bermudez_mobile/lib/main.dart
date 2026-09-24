import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(
    fileName: "assets/.env",
  );

  // Lab Activity 5: Initializes Firebase before starting the Flutter application.
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          ThemeProvider(),
      child:
          const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final themeProvider =
        context.watch<ThemeProvider>();

    return ScreenUtilInit(
      designSize:
          const Size(
        412,
        715,
      ),
      minTextAdapt: true,
      builder:
          (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner:
              false,

          themeMode:
              themeProvider.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,

          theme: ThemeData(
            brightness:
                Brightness.light,
            fontFamily:
                "Poppins",
            scaffoldBackgroundColor:
                const Color(
              0xFFF8F8F8,
            ),
            colorScheme:
                ColorScheme.fromSeed(
              seedColor:
                  const Color(
                0xFF003566,
              ),
              primary:
                  const Color(
                0xFF003566,
              ),
              secondary:
                  const Color(
                0xFFCCA000,
              ),
            ),
            appBarTheme:
                const AppBarTheme(
              backgroundColor:
                  Color(
                0xFF001D3D,
              ),
              foregroundColor:
                  Colors.white,
              elevation: 0,
            ),
            cardTheme:
                CardThemeData(
              elevation: 4,
              color: Colors.white,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
            ),
            elevatedButtonTheme:
                ElevatedButtonThemeData(
              style:
                  ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(
                  fontFamily:
                      "Poppins",
                ),
              ),
            ),
          ),

          darkTheme:
              ThemeData(
            brightness:
                Brightness.dark,
            fontFamily:
                "Poppins",
            scaffoldBackgroundColor:
                const Color(
              0xFF000814,
            ),
            colorScheme:
                ColorScheme.fromSeed(
              brightness:
                  Brightness.dark,
              seedColor:
                  const Color(
                0xFFCCA000,
              ),
              primary:
                  const Color(
                0xFF003566,
              ),
              secondary:
                  const Color(
                0xFFF0CB46,
              ),
            ),
            appBarTheme:
                const AppBarTheme(
              backgroundColor:
                  Color(
                0xFF000814,
              ),
              foregroundColor:
                  Colors.white,
              elevation: 0,
            ),
          ),

          initialRoute: '/',

          routes: {
            '/': (context) =>
                const SplashScreen(),

            '/signin':
                (context) =>
                    const SignInScreen(),

            // Lab Activity 5 - Enhancement 2: Opens the Firebase account registration screen.
            '/signup':
                (context) =>
                    const SignUpScreen(),

            '/home':
                (context) =>
                    const HomeScreen(),

            '/profile':
                (context) =>
                    const ProfileScreen(),
          },
        );
      },
    );
  }
}