// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'editar_foto.dart';

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock de datos alumno
    final alumno = {
      "nombre": "Celeste Torrico",
      "correo": "celeste.torrico@aula.edu",
      "carrera": "Ingeniería Informática",
      "materias": ["Matemáticas", "Lenguaje", "Ciencias"],
      "foto": "https://randomuser.me/api/portraits/women/68.jpg"
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
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(alumno["foto"] as String),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: EditarFotoButton(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              alumno["nombre"] as String,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(child: Text(alumno["correo"] as String)),
          const Divider(height: 35),
          const Text("Materias inscritas:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...(alumno["materias"] as List<String>).map((m) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(m),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
