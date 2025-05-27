// ignore_for_file: use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'tarea_detalle_screen.dart';

class TareasAsignadasScreen extends StatelessWidget {
  // Mock data
  final List<Map<String, dynamic>> tareas = [
    {
      "titulo": "Ensayo de lectura",
      "materia": "Lenguaje",
      "fecha_entrega": "2025-05-25",
      "entregada": false,
      "descripcion": "Escribe un ensayo sobre la lectura dada.",
    },
    {
      "titulo": "Problemas de álgebra",
      "materia": "Matemáticas",
      "fecha_entrega": "2025-05-20",
      "entregada": true,
      "descripcion": "Resuelve los ejercicios del libro de álgebra.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas Asignadas'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tareas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = tareas[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TareaDetalleScreen(
                    titulo: t["titulo"],
                    descripcion: t["descripcion"] ?? "",
                    materia: t["materia"],
                    fechaEntrega: t["fecha_entrega"],
                    entregada: t["entregada"] ?? false,
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: Icon(
                  Icons.assignment,
                  color: t["entregada"] ? Colors.green : Colors.orange,
                ),
                title: Text(t["titulo"]),
                subtitle: Text(
                  "Materia: ${t["materia"]}\nEntrega: ${t["fecha_entrega"]}",
                ),
                trailing: t["entregada"]
                    ? const Text("Entregada",
                        style: TextStyle(color: Colors.green))
                    : const Text("Pendiente",
                        style: TextStyle(color: Colors.orange)),
              ),
            ),
          );
        },
      ),
    );
  }
}
