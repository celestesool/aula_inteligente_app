// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_import, unnecessary_to_list_in_spreads
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock de datos alumno con tipos explícitos
    final Map<String, dynamic> alumno = {
      "nombre_completo": "Celeste Torrico",
      "email": "celeste.torrico@aula.edu",
      "materias": ["Matemáticas", "Lenguaje", "Ciencias"],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Colors.blue[700],
              child: const Icon(
                Icons.person,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              alumno["nombre_completo"]
                  as String, // Conversión explícita a String
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
              child: Text(alumno["email"] as String)), // Conversión explícita
          const Divider(height: 35),
          const Text(
            "Materias inscritas:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...(alumno["materias"] as List<String>)
              .map((m) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(m),
                      ],
                    ),
                  ))
              .toList(), 
        ],
      ),
    );
  }
}
