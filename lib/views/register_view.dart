import 'package:demo_project/services/auth/auth_exceptions.dart';
import 'package:demo_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/constants/routes.dart';
import 'package:demo_project/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
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
                            await AuthService.firebase().createUser(
                              email: email,
                              password: password,
                            );
                            AuthService.firebase().sendEmailVerification();
                            if (context.mounted) {
                              Navigator.of(context).pushNamed(verifyEmailRoute);
                            }
                          } on WeakPasswordAuthException {
                            if (context.mounted) {
                              await showErrorDialog(
                                context,
                                'Weak Password! Enter a strong password.',
                              );
                            }
                          } on EmailAlreadyInUseAuthException {
                            if (context.mounted) {
                              await showErrorDialog(
                                context,
                                'Email already in use.',
                              );
                            }
                          } on InvalidEmailAuthException {
                            if (context.mounted) {
                              await showErrorDialog(
                                context,
                                'Invalid email! Enter a valid email.',
                              );
                            }
                          } on GenericAuthException {
                            if (context.mounted) {
                              await showErrorDialog(
                                context,
                                'Failed to register!',
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 22, 141, 238),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                        },
                        child: const Text(
                          "Already registered? Login here!",
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
