import 'package:flutter/material.dart';
import 'package:demo_project/services/auth/auth_service.dart';
import 'package:demo_project/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verify the email",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("We've sent the verification email."),
              const SizedBox(height: 8),
              const Text(
                "If you haven't received it yet, click the button below.",
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  try {
                    AuthService.firebase().sendEmailVerification();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Verification email sent."),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to send email verification: $e",
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Send email verification"),
              ),
              const SizedBox(height: 0),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(registerRoute, (_) => false);
                  }
                },
                child: const Text("Stuck! Register again!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
