// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'resumen_card.dart';
import 'grafico_desempeno.dart';
import '../HistorialAcademico/HistorialAcademicoScreen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ----- NUEVO: Acceso directo al Historial Académico -----
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistorialAcademicoScreen(),
                ),
              );
            },
            child: Card(
              color: Colors.blue[50],
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Icon(Icons.history_edu, color: Colors.blue[700], size: 36),
                    SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        "Historial Académico",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.blue[700], size: 20)
                  ],
                ),
              ),
            ),
          ),
          // -----------------------------------------------
          const SizedBox(height: 16),
          const Text(
            "Resumen de desempeño",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: ResumenCard(title: "Promedio", value: "85")),
              SizedBox(width: 8),
              Expanded(child: ResumenCard(title: "Asistencias", value: "95%")),
              SizedBox(width: 8),
              Expanded(child: ResumenCard(title: "IA", value: "Alto")),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            "Predicción de Rendimiento (IA)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          GraficoDesempeno(),
        ],
      ),
    );
  }
}
