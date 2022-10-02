import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/core/index.dart';
import 'package:nasa/providers/auth.dart';
import 'package:nasa/providers/shared_preferences.dart';
import 'package:nasa/screens/home/home.dart';
import 'package:nasa/screens/spalsh_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(ProviderScope(
      overrides: [spProvider.overrideWithValue(sharedPreferences)],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final auth = ref.watch(authProvider);
        final futureAuth = ref.watch(futureAuthProvider);
        return MaterialApp(
          title: 'NASA App',
          theme: AppTheme.myThemeData,
          // home: const WelcomeScreen(),
          home: futureAuth.when(data: (data) {
            return auth.isAuth ? Home() : SplashScreen();
          }, error: (e, st) {
            return Scaffold(
              body: Center(child: Text(e.toString())),
            );
          }, loading: () {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }),
          routes: AppRoute.routes,
        );
      },
    );
  }
}
