// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class TareaCard extends StatelessWidget {
  final String titulo;
  final String materia;
  final String estado;
  final String fecha;

  const TareaCard({
    Key? key,
    required this.titulo,
    required this.materia,
    required this.estado,
    required this.fecha,
  }) : super(key: key);

  Color getEstadoColor() {
    switch (estado) {
      case "Pendiente":
        return Colors.orange;
      case "Entregada":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: Icon(Icons.assignment, color: getEstadoColor()),
        title:
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Materia: $materia\nEntrega: $fecha'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: getEstadoColor().withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            estado,
            style: TextStyle(
              color: getEstadoColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          // se pude hacer el detalle de tarea
        },
      ),
    );
  }
}
