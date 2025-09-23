import 'package:demo_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/constants/routes.dart';
import 'package:demo_project/enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Log Out"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
