import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/screens/details_screen.dart';
import 'package:password_manager/screens/profile_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/screens/forgot_password_screen.dart';
import 'package:password_manager/screens/login_screen.dart';
import 'package:password_manager/screens/signup_screen.dart';
import 'package:password_manager/screens/splash_screen.dart';
import 'package:password_manager/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeySafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffff7754)),
        useMaterial3: true,
        // fontFamily: 'DM Sans',
      ),
      home: const RootScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot_pass': (context) => const ForgotPasswordScreen(),
        '/password_details': (context) => PasswordDetailsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(route: '/login');
        } else if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null && !user.emailVerified) {
            return const SplashScreen(route: '/login');
          } else {
            return const SplashScreen(route: '/home');
          }
        } else {
          return const SplashScreen(route: '/login');
        }
      },
    );
  }
}
