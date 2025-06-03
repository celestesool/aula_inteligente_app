// lib/screens/materias/materias_screen.dart
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/materia.dart';
import '../../services/materia_service.dart';
import '../../providers/auth_provider.dart';
import 'materia_detalle_screen.dart';

class MateriasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final usuario = auth.usuario;
    final token = auth.token;

    if (usuario == null || token == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Materias'), centerTitle: true),
        body: const Center(child: Text('Por favor inicia sesión.')),
      );
    }

    // ⚠️ El campo correcto es alumnoId (NO alumnold, revisa el modelo Usuario)
    final int? idAlumno = usuario.alumnoId;

    if (idAlumno == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Materias'), centerTitle: true),
        body: const Center(child: Text('Solo alumnos pueden ver materias.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Materias'), centerTitle: true),
      body: FutureBuilder<List<Materia>>(
        future: MateriaService().getMateriasPorAlumno(idAlumno, token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes materias en curso.'));
          }
          final materias = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: materias.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => Card(
              child: ListTile(
                title: Text(materias[i].nombre),
                subtitle: Text(materias[i].descripcion),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MateriaDetalleScreen(
                        idMateria: materias[i].id,
                        nombre: materias[i].nombre,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
