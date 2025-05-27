// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
class HistorialAcademicoScreen extends StatelessWidget {
  // Aquí deberías traer estos datos desde el backend con el ID del alumno autenticado
  final List<Map<String, dynamic>> notas = [
    {"materia": "Matemáticas", "nota": 86, "observacion": "Buen desempeño"},
    {"materia": "Lenguaje", "nota": 91, "observacion": null},
    {"materia": "Ciencias", "nota": 74, "observacion": "Debe participar más"},
  ];

  final List<Map<String, dynamic>> asistencias = [
    {"materia": "Matemáticas", "fecha": "2025-05-01", "presente": true},
    {"materia": "Matemáticas", "fecha": "2025-05-02", "presente": false},
    {"materia": "Lenguaje", "fecha": "2025-05-01", "presente": true},
  ];

  final List<Map<String, dynamic>> participaciones = [
    {"materia": "Ciencias", "fecha": "2025-05-01", "puntaje": 1.0},
    {"materia": "Ciencias", "fecha": "2025-05-02", "puntaje": 0.0},
    {"materia": "Lenguaje", "fecha": "2025-05-01", "puntaje": 0.5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Académico'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Notas finales",
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...notas.map((n) => ListTile(
                title: Text("${n['materia']}: ${n['nota']}"),
                subtitle:
                    n['observacion'] != null ? Text(n['observacion']) : null,
                leading: const Icon(Icons.grade, color: Colors.blue),
              )),
          const Divider(height: 32),
          const Text("Asistencias",
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...asistencias.map((a) => ListTile(
                title: Text("${a['materia']} (${a['fecha']})"),
                leading: Icon(
                  a['presente'] ? Icons.check_circle : Icons.cancel,
                  color: a['presente'] ? Colors.green : Colors.red,
                ),
                subtitle: Text(a['presente'] ? "Presente" : "Ausente"),
              )),
          const Divider(height: 32),
          const Text("Participaciones",
              style: TextStyle(fontWeight: FontWeight.bold)),
          ...participaciones.map((p) => ListTile(
                title: Text("${p['materia']} (${p['fecha']})"),
                subtitle: Text("Puntaje: ${p['puntaje']}"),
                leading:
                    const Icon(Icons.record_voice_over, color: Colors.indigo),
              )),
        ],
      ),
    );
  }
}
