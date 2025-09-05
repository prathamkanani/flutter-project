import 'package:demo_project/firebase_options.dart';
import 'package:demo_project/views/login_view.dart';
import 'package:demo_project/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  /// It ensures that the essential low-level services needed to run a Flutter app are set up before the runApp() function is called.
  /// Think of it as building the bridge between your Flutter code and the native device (iOS/Android). Normally, runApp() builds this bridge for you automatically. However, if you need to talk to the native side before runApp() starts drawing your widgets, you must build the bridge manually first.

  /// USE CASE: WHEN INITIALIZING FIREBASE APP
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;
            // if (user?.emailVerified ?? false) {
            //   print("You are verified user.");
            // } else {
            //   return const VerifyEmailView();
            // }
            return const LoginView();
          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}

