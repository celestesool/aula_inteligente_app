// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class MateriaDetalleScreen extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String grado;
  final List<Map<String, dynamic>> tareas;

  const MateriaDetalleScreen({
    Key? key,
    required this.nombre,
    required this.descripcion,
    required this.grado,
    required this.tareas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text('Materia:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(nombre, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text('Descripción:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(descripcion.isNotEmpty ? descripcion : 'Sin descripción'),
            const SizedBox(height: 16),
            Text('Grado:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(grado),
            const SizedBox(height: 24),
            if (tareas.isNotEmpty) ...[
              Text('Tareas:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...tareas.map((t) => Card(
                    child: ListTile(
                      leading: Icon(Icons.assignment, color: Colors.blue[700]),
                      title: Text(t["titulo"]),
                      subtitle: Text("Entrega: ${t["fecha"]}"),
                    ),
                  )),
            ] else
              const Text('No hay tareas asignadas.'),
          ],
        ),
      ),
    );
  }
}
