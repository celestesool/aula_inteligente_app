// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MateriaCard extends StatelessWidget {
  final String nombre;
  final String docente;
  final double progreso;
  final Color color;

  const MateriaCard({
    Key? key,
    required this.nombre,
    required this.docente,
    required this.progreso,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.menu_book, color: Colors.white),
        ),
        title:
            Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Docente: $docente'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${(progreso * 100).toInt()}%'),
            SizedBox(
              width: 50,
              child: LinearProgressIndicator(
                value: progreso,
                color: color,
                backgroundColor: color.withOpacity(0.2),
                minHeight: 7,
              ),
            ),
          ],
        ),
        onTap: () {
          // Aquí podemos  hacer e detalle de materia
        },
      ),
    );
  }
}
