import 'package:flutter/material.dart';
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
      debugShowCheckedModeBanner: false, // Désactive la banderole "Debug"
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
