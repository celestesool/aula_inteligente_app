// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class GraficoDesempeno extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock gráfico emm barras simples usando contenedores
    final List<Map<String, dynamic>> data = [
      {"materia": "Matemáticas", "valor": 90},
      {"materia": "Lenguaje", "valor": 75},
      {"materia": "Ciencias", "valor": 82},
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(item["materia"] as String),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (item["valor"] as int) / 100,
                          color: Colors.blue[700],
                          backgroundColor: Colors.blue[100],
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text("${item["valor"]}%"),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
