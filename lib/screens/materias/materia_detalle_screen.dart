// screens/materias/materia_detalle_screen.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MateriaDetalleScreen extends StatelessWidget {
  final int idMateria;
  final String nombre;

  const MateriaDetalleScreen({
    Key? key,
    required this.idMateria,
    required this.nombre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Materia:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(nombre, style: const TextStyle(fontSize: 18)),
            // Puedes agregar aquí la descripción u otros detalles si deseas.
          ],
        ),
      ),
    );
  }
}
