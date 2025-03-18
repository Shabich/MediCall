import 'package:flutter/material.dart';
import 'package:medicall/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rappels Médicaments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthRedirector(),
      routes: appRoutes,
    );
  }
}

class AuthRedirector extends StatefulWidget {
  const AuthRedirector({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthRedirectorState createState() => _AuthRedirectorState();
}

class _AuthRedirectorState extends State<AuthRedirector> {
  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('nom') ?? '';
    final firstName = prefs.getString('prenom') ?? '';
    final email = prefs.getString('adresse_mail') ?? '';

    if (name.isNotEmpty && firstName.isNotEmpty && email.isNotEmpty) {
      return '/rappels';
    } else {
      return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Future.microtask(() {
          Navigator.of(context).pushReplacementNamed(snapshot.data!);
        });

        return const SizedBox.shrink();
      },
    );
  }
}
