// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'materia_card.dart';

class MateriasScreen extends StatelessWidget {
  // Mock data de materias
  final List<Map<String, dynamic>> materias = [
    {
      "nombre": "Matemáticas",
      "docente": "Prof. García",
      "progreso": 0.8,
      "color": Colors.blue
    },
    {
      "nombre": "Lenguaje",
      "docente": "Prof. Rojas",
      "progreso": 0.5,
      "color": Colors.lightBlue
    },
    {
      "nombre": "Ciencias",
      "docente": "Prof. Pérez",
      "progreso": 0.9,
      "color": Colors.indigo
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: materias.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => MateriaCard(
          nombre: materias[i]["nombre"],
          docente: materias[i]["docente"],
          progreso: materias[i]["progreso"],
          color: materias[i]["color"],
        ),
      ),
    );
  }
}
