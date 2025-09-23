import 'package:demo_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/constants/routes.dart';
import 'package:demo_project/views/login_view.dart';
import 'package:demo_project/views/notes_view.dart';
import 'package:demo_project/views/verify_email_view.dart';
import 'package:demo_project/views/register_view.dart';
// import 'dart:developer' as devtools show log;

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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}