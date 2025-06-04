// lib/widgets/bottom_nav.dart

// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue[700],
      unselectedItemColor: Colors.blueGrey[200],
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics), // El nuevo ícono para Notas/IA
          label: 'Notas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Materias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Control',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
