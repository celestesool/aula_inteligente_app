// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'tarea_card.dart';
import 'tarea_detalle_screen.dart';
import 'TareasAsignadasScreen.dart';

class TareasScreen extends StatelessWidget {
  // Ejemplo simulado
  final List<Map<String, dynamic>> tareas = [
    {
      "titulo": "Ensayo de lectura",
      "materia": "Lenguaje",
      "fecha": "2025-05-25",
      "descripcion": "Escribe un ensayo sobre la lectura dada.",
      "entregada": false,
      "archivoUrl": null,
      "calificacion": null,
    },
    {
      "titulo": "Problemas de álgebra",
      "materia": "Matemáticas",
      "fecha": "2025-05-20",
      "descripcion": "Resuelve los ejercicios del libro de álgebra.",
      "entregada": true,
      "archivoUrl": "algebra.pdf",
      "calificacion": 85.0,
    },
    {
      "titulo": "Informe de laboratorio",
      "materia": "Ciencias",
      "fecha": "2025-05-28",
      "descripcion": "Entrega el informe del experimento.",
      "entregada": false,
      "archivoUrl": null,
      "calificacion": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: "Ver Tareas Asignadas",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TareasAsignadasScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tareas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final t = tareas[i];
          return TareaCard(
            titulo: t["titulo"],
            materia: t["materia"],
            fecha: t["fecha"],
            estado: t["entregada"] == true ? "Entregada" : "Pendiente",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TareaDetalleScreen(
                    titulo: t["titulo"],
                    descripcion: t["descripcion"] ?? "",
                    materia: t["materia"],
                    fechaEntrega: t["fecha"],
                    entregada: t["entregada"] ?? false,
                    archivoUrl: t["archivoUrl"],
                    calificacion: t["calificacion"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
