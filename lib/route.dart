import 'pages/medicament_page.dart';
import 'pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/rappels_page.dart';
import 'pages/profile_page.dart'; // Importer la page de profil

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginPage(),
  '/rappels': (context) => const ReminderListPage(),
  '/profile': (context) => const ProfilePage(), // Ajout de la route
  '/signup': (context) => const SignUpPage(), // Ajout de la route
  '/medicaments': (context) => const MedicamentListPage()
};
