// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'materia_card.dart';
import 'materia_detalle_screen.dart';

class MateriasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> materias = [
    {
      "nombre": "Matemáticas",
      "docente": "Prof. García",
      "descripcion": "Álgebra, geometría y más.",
      "grado": "3ro Secundaria",
      "tareas": [
        {"titulo": "Problemas de álgebra", "fecha": "2025-05-20"},
        {"titulo": "Proyecto de geometría", "fecha": "2025-06-01"},
      ],
    },
    {
      "nombre": "Lenguaje",
      "docente": "Prof. Rojas",
      "descripcion": "Gramática y comprensión lectora.",
      "grado": "3ro Secundaria",
      "tareas": [
        {"titulo": "Ensayo de lectura", "fecha": "2025-05-25"},
      ],
    },
    {
      "nombre": "Ciencias",
      "docente": "Prof. Pérez",
      "descripcion": "Física, química y biología.",
      "grado": "3ro Secundaria",
      "tareas": [
        {"titulo": "Informe de laboratorio", "fecha": "2025-05-28"},
      ],
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
          itemBuilder: (context, i) {
            final m = materias[i];
            return MateriaCard(
              nombre: m["nombre"],
              docente: m["docente"] ?? "",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MateriaDetalleScreen(
                      nombre: m["nombre"],
                      descripcion: m["descripcion"] ?? "",
                      grado: m["grado"] ?? "",
                      tareas: m["tareas"] ?? [],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
