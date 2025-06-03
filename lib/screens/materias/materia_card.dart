// lib/screens/materias/materia_card.dart

// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MateriaCard extends StatelessWidget {
  final String nombre;
  final String docente;
  final String periodo;
  final VoidCallback? onTap;

  const MateriaCard({
    Key? key,
    required this.nombre,
    required this.docente,
    required this.periodo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.menu_book, color: Colors.white),
        ),
        title:
            Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Docente: $docente'),
        trailing: Text(periodo),
        onTap: onTap,
      ),
    );
  }
}
