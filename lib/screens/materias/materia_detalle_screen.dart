// ignore_for_file: unnecessary_null_comparison, use_super_parameters

import 'package:flutter/material.dart';
import '../../models/materia.dart';

class MateriaDetalleScreen extends StatelessWidget {
  final Materia materia;
  final List<Map<String, dynamic>> notas;

  const MateriaDetalleScreen({
    Key? key,
    required this.materia,
    required this.notas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materia.nombre),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              materia.nombre,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (materia.descripcion != null && materia.descripcion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  materia.descripcion,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Notas actuales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (notas.isEmpty)
              const Text(
                'No hay notas registradas para este año',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...notas.map((nota) => ListTile(
                    leading: const Icon(Icons.grade, color: Colors.amber),
                    title: Text(nota['tipo'] ?? 'Sin tipo'),
                    subtitle: Text('Nota: ${nota['nota']}'),
                  )),
          ],
        ),
      ),
    );
  }
}
