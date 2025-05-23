// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'resumen_card.dart';
import 'grafico_desempeno.dart';

// ignore: use_key_in_widget_constructors
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
