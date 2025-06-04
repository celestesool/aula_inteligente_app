// lib/app.dart

// ignore_for_file: use_super_parameters, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/asistencia_participacion/asistencia_participacion_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/materias/materias_screen.dart';
import 'screens/perfil/perfil_screen.dart';
import 'screens/notas_predicciones/notas_predicciones_screen.dart';
import 'widgets/bottom_nav.dart';
import 'utils/theme.dart';

class AulaInteligenteApp extends StatefulWidget {
  const AulaInteligenteApp({Key? key}) : super(key: key);

  @override
  State<AulaInteligenteApp> createState() => _AulaInteligenteAppState();
}

class _AulaInteligenteAppState extends State<AulaInteligenteApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Si no está logueado, muestra el login
    if (authProvider.usuario == null || authProvider.token == null) {
      return MaterialApp(
        title: 'Aula Inteligente',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const LoginScreen(),
      );
    }

    // Pantallas para el BottomNavigationBar
    final List<Widget> _screens = [
      DashboardScreen(),
       NotasPrediccionesScreen(),
      MateriasScreen(),
      AsistenciaParticipacionScreen(),
      PerfilScreen(),

    ];

    return MaterialApp(
      title: 'Aula Inteligente',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
