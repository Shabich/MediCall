import 'package:flutter/material.dart';
import 'package:medicall/pages/historique_page.dart';
import 'package:medicall/pages/home_page.dart';
import 'package:medicall/pages/main_page.dart';
import 'pages/medicament_page.dart';
import 'pages/signup_page.dart';
import 'pages/login_page.dart';
import 'pages/rappels_page.dart';
import 'pages/profile_page.dart';
import 'app_layout.dart'; // Import du layout

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomePage(),

  '/home': (context) => const AppLayout(
      child: MenuPage()), // rajouter une page pour decrire l'application

  '/rappels': (context) =>
      AppLayout(child: ReminderPage()), // Enveloppé dans AppLayout
  '/profile': (context) =>
      const AppLayout(child: ProfilePage()), // Enveloppé dans AppLayout

  '/signup': (context) => const SignUpPage(),
  '/login': (context) => const LoginPage(),

  '/medicaments': (context) =>
      const AppLayout(child: MedicamentListPage()), // Enveloppé dans AppLayout

  '/historique': (context) =>
      const AppLayout(child: HistoriqueListPage()), // Enveloppé dans AppLayout
};
