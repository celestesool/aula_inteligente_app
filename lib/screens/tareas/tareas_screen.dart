// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'tarea_card.dart';

class TareasScreen extends StatelessWidget {
  // Mock data de tareas
  final List<Map<String, dynamic>> tareas = [
    {
      "titulo": "Ensayo de lectura",
      "materia": "Lenguaje",
      "estado": "Pendiente",
      "fecha": "2025-05-25",
    },
    {
      "titulo": "Problemas de álgebra",
      "materia": "Matemáticas",
      "estado": "Entregada",
      "fecha": "2025-05-20",
    },
    {
      "titulo": "Informe de laboratorio",
      "materia": "Ciencias",
      "estado": "Pendiente",
      "fecha": "2025-05-28",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tareas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => TareaCard(
          titulo: tareas[i]["titulo"],
          materia: tareas[i]["materia"],
          estado: tareas[i]["estado"],
          fecha: tareas[i]["fecha"],
        ),
      ),
    );
  }
}
