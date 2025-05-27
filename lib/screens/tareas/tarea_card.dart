// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class TareaCard extends StatelessWidget {
  final String titulo;
  final String materia;
  final String fecha;
  final VoidCallback? onTap;

  const TareaCard({
    Key? key,
    required this.titulo,
    required this.materia,
    required this.fecha,
    this.onTap, required estado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: const Icon(Icons.assignment, color: Colors.blue),
        title:
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Materia: $materia\nEntrega: $fecha'),
        onTap: onTap, 
      ),
    );
  }
}
