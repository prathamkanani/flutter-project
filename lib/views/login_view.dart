import 'package:demo_project/constants/routes.dart';
import 'package:demo_project/firebase_options.dart';
import 'package:demo_project/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.4),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _email,

                        ///IMP FOR PASSWORD SPECIFIC FIELDS
                        // enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _password,

                        ///IMP FOR PASSWORD SPECIFIC FIELDS
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,

                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                            final user = FirebaseAuth.instance.currentUser;
                            if(user?.emailVerified ?? false) {
                              // email verified
                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  notesRoute,
                                  (route) => false,
                                );
                              }
                            } else {
                              // email not verified
                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  verifyEmailRoute,
                                  (route) => false,
                                );
                              }
                            }                            
                          } on FirebaseAuthException catch (e) {
                            if (context.mounted && e.code == "user-not-found") {
                              await showErrorDialog(context, 'User not found!');
                            } else if (context.mounted &&
                                e.code == "wrong-password") {
                              await showErrorDialog(context, 'Wrong Password!');
                            } else if (context.mounted &&
                                e.code == "invalid-email") {
                              await showErrorDialog(context, 'Invalid Email!');
                            } else {
                              if (context.mounted) {
                                await showErrorDialog(
                                  context,
                                  'Error ${e.code}',
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              await showErrorDialog(context, e.toString());
                            }
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 22, 141, 238),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute,
                            (_) => false,
                          );
                        },
                        child: const Text(
                          "Not registered yet? Register here!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 22, 141, 238),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
          }
        },
      ),
    );
  }
}
