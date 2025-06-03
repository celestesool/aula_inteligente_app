// screens/HistorialAcademico/HistorialAcademicoScreen.dart
// ignore_for_file: file_names, unnecessary_string_interpolations, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/historial_service.dart';

class HistorialAcademicoScreen extends StatefulWidget {
  const HistorialAcademicoScreen({super.key});

  @override
  State<HistorialAcademicoScreen> createState() =>
      _HistorialAcademicoScreenState();
}

class _HistorialAcademicoScreenState extends State<HistorialAcademicoScreen> {
  Map<String, dynamic> notas = {};
  Map<String, dynamic> asistencias = {};
  Map<String, dynamic> participacion = {};
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final alumnoId = auth.usuario!.alumnoId!;
    final token = auth.token!;

    notas = await HistorialService.getNotas(alumnoId, token);
    asistencias = await HistorialService.getAsistencias(alumnoId, token);
    participacion = await HistorialService.getParticipacion(alumnoId, token);

    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final anios = (notas['notas'] ?? {}).keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial Académico')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: anios.map<Widget>((anio) {
          final gradosRaw = notas['notas'][anio]['grados'] ?? {};
          final grados = Map<String, dynamic>.from(gradosRaw);
          final grado = grados.keys.isNotEmpty ? grados.keys.first : '';
          final titulo = "$anio - $grado";
          final periodosRaw =
              grado.isNotEmpty ? grados[grado]['periodos'] ?? {} : {};
          final periodos = Map<String, dynamic>.from(periodosRaw);

          return ExpansionTile(
            title: Text(titulo,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            children: periodos.keys.map<Widget>((periodo) {
              final materiasNotasRaw = periodos[periodo] ?? {};
              final materiasNotas = Map<String, dynamic>.from(materiasNotasRaw);

              final asistPorPeriodoRaw = ((asistencias['asistencias'] ??
                      {})[anio]?['grados']?[grado]?['periodos']?[periodo] ??
                  {});
              final asistPorPeriodo =
                  Map<String, dynamic>.from(asistPorPeriodoRaw);

              final partPorPeriodoRaw = ((participacion['participaciones'] ??
                      {})[anio]?['grados']?[grado]?['periodos']?[periodo] ??
                  {});
              final partPorPeriodo =
                  Map<String, dynamic>.from(partPorPeriodoRaw);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$periodo",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      if (materiasNotas.isNotEmpty) ...[
                        const Text("Notas:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...materiasNotas.entries.map((e) {
                          final nombreMateria = e.key;
                          final valueList = e.value as List? ?? [];
                          final nota = valueList.isNotEmpty
                              ? valueList.first['valor']
                              : null;
                          final obs = valueList.isNotEmpty
                              ? valueList.first['observaciones']
                              : null;
                          return ListTile(
                            leading:
                                const Icon(Icons.grade, color: Colors.blue),
                            title: Text("$nombreMateria: ${nota ?? '-'}"),
                            subtitle: obs != null ? Text(obs) : null,
                          );
                        }).toList(),
                      ],
                      if (asistPorPeriodo.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text("Asistencias:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...asistPorPeriodo.entries.map((e) {
                          final materia = e.key;
                          final asistList = e.value as List? ?? [];
                          return Column(
                            children: asistList.map<Widget>((a) {
                              final valor = a['valor'];
                              return ListTile(
                                leading: const Icon(Icons.check_circle,
                                    color: Colors.blue),
                                title: Text("$materia"),
                                subtitle: Text(
                                    "Asistencia: ${valor?.toStringAsFixed(1) ?? '-'}"),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ],
                      if (partPorPeriodo.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text("Participación:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...partPorPeriodo.entries.map((e) {
                          final materia = e.key;
                          final partList = e.value as List? ?? [];
                          return Column(
                            children: partList.map<Widget>((p) {
                              final valor = p['valor'];
                              return ListTile(
                                leading: const Icon(Icons.record_voice_over,
                                    color: Colors.indigo),
                                title: Text("$materia"),
                                subtitle: Text("Puntaje: ${valor ?? '-'}"),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
