// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../api_routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotasPrediccionesScreen extends StatefulWidget {
  const NotasPrediccionesScreen({Key? key}) : super(key: key);

  @override
  State<NotasPrediccionesScreen> createState() =>
      _NotasPrediccionesScreenState();
}

class _NotasPrediccionesScreenState extends State<NotasPrediccionesScreen> {
  late Future<List<_NotaPrediccion>> _futureNotasPredicciones;

  @override
  void initState() {
    super.initState();
    final usuario = Provider.of<AuthProvider>(context, listen: false).usuario;
    final int? alumnoId = usuario?.alumnoId; // usa alumnoId aquí
    if (alumnoId != null) {
      _futureNotasPredicciones = fetchNotasPredicciones(alumnoId);
    }
  }

  Future<List<_NotaPrediccion>> fetchNotasPredicciones(int alumnoId) async {
    // 1. Obtener notas
    final notasRes =
        await http.get(Uri.parse(ApiRoutes.notasTrimestrePorAlumno(alumnoId)));
    final notas = notasRes.statusCode == 200
        ? List<Map<String, dynamic>>.from(jsonDecode(notasRes.body))
        : [];

    // 2. Obtener predicciones
    final predRes =
        await http.get(Uri.parse(ApiRoutes.prediccionesPorAlumno(alumnoId)));
    final predicciones = predRes.statusCode == 200
        ? List<Map<String, dynamic>>.from(jsonDecode(predRes.body))
        : [];

    // 3. Unir datos por materia (suponiendo que ambos traen id de materia)
    final result = <_NotaPrediccion>[];

    for (final nota in notas) {
      final prediccion = predicciones.firstWhere(
        (p) => p['materia_id'] == nota['materia_id'],
        orElse: () => null,
      );
      result.add(_NotaPrediccion(
        materia: nota['materia_nombre'] ?? 'Materia',
        nota: nota['nota']?.toString() ?? '-',
        prediccion: prediccion != null
            ? prediccion['prediccion']?.toString() ?? '-'
            : '-',
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas y Predicciones'),
      ),
      body: FutureBuilder<List<_NotaPrediccion>>(
        future: _futureNotasPredicciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Sin datos.'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.materia,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Nota: ${item.nota}  •  Predicción IA: ${item.prediccion}'),
                leading: const Icon(Icons.assessment),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotaPrediccion {
  final String materia;
  final String nota;
  final String prediccion;

  _NotaPrediccion({
    required this.materia,
    required this.nota,
    required this.prediccion,
  });
}
