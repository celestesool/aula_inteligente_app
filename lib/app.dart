// lib/app.dart

// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/materias/materias_screen.dart';
import 'screens/tareas/tareas_screen.dart';
import 'screens/perfil/perfil_screen.dart';
import 'widgets/bottom_nav.dart';
import 'utils/theme.dart';

class AulaInteligenteApp extends StatefulWidget {
  const AulaInteligenteApp({Key? key}) : super(key: key);

  @override
  State<AulaInteligenteApp> createState() => _AulaInteligenteAppState();
}

class _AulaInteligenteAppState extends State<AulaInteligenteApp> {
  int _currentIndex = 0;
  bool _loggedIn = false;

  // Lista de pantallas para el BottomNavigationBar
  final List<Widget> _screens = [
    DashboardScreen(),
    MateriasScreen(),
    TareasScreen(),
    PerfilScreen(),
  ];

  // Función para simular el login
  void _login() {
    setState(() {
      _loggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula Inteligente',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: _loggedIn
          ? Scaffold(
              body: _screens[_currentIndex],
              bottomNavigationBar: BottomNavBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            )
          : LoginScreen(onLogin: _login),
    );
  }
}
