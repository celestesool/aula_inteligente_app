// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_to_list_in_spreads, use_super_parameters, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../api_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../HistorialAcademico/HistorialAcademicoScreen.dart';
import 'resumen_card.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double promedio = 0;
  double porcentajeAsistencias = 0;
  String nivelIA = '...';
  List<Map<String, dynamic>> graficoMaterias = [];
  List<Map<String, dynamic>> notasEnCurso = [];
  List<Map<String, dynamic>> notasAntiguas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final usuario = auth.usuario!;
    final token = auth.token!;
    int alumnoId = usuario.alumnoId!;

    // ---------- 1. TRAER CURSO ACTUAL Y MATERIAS EN CURSO ----------
    String gradoActual = '';
    String gestionActual = '';
    Set<String> nombresMateriasEnCurso = {};

    final materiasRes = await http.get(
      Uri.parse(ApiRoutes.materiasPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (materiasRes.statusCode == 200) {
      final jsonResp = json.decode(materiasRes.body);
      final materiasPorGestion = jsonResp['materias_por_gestion'] as List;
      for (final x in materiasPorGestion) {
        if (x['estado'] == 'en curso') {
          gradoActual = x['grado'].toString();
          gestionActual = x['gestion'].toString();
          for (final m in x['materias']) {
            nombresMateriasEnCurso.add(m['nombre']);
          }
        }
      }
    }

    // ---------- 2. TRAER PROMEDIOS ----------
    final promediosRes = await http.get(
      Uri.parse(ApiRoutes.promediosPorGrado(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (promediosRes.statusCode == 200) {
      final promediosJson = json.decode(promediosRes.body);
      var proms = promediosJson['promedios_por_grado'] as List;
      if (proms.isNotEmpty) {
        promedio = proms.last['promedio'] * 1.0;
        graficoMaterias = proms
            .map<Map<String, dynamic>>((e) => {
                  "materia": e["grado"].toString(),
                  "valor": (e["promedio"] is int)
                      ? e["promedio"].toDouble()
                      : double.tryParse(e["promedio"].toString()) ?? 0
                })
            .toList();
      }
      if (promedio >= 85) {
        nivelIA = "Alto";
      } else if (promedio >= 70) {
        nivelIA = "Medio";
      } else {
        nivelIA = "Bajo";
      }
    }

    // ---------- 3. TRAER ASISTENCIAS ----------
    final asistenciasRes = await http.get(
      Uri.parse(ApiRoutes.asistenciasPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (asistenciasRes.statusCode == 200) {
      final asistenciasJson = json.decode(asistenciasRes.body);
      int presentes = 0;
      int total = 0;
      final asistencias =
          asistenciasJson['asistencias'] as Map<String, dynamic>;
      for (var gestion in asistencias.values) {
        for (var grado in (gestion['grados'] as Map<String, dynamic>).values) {
          for (var periodo
              in (grado['periodos'] as Map<String, dynamic>).values) {
            for (var materia in (periodo as Map<String, dynamic>).values) {
              for (var registro in (materia as List)) {
                total++;
                if (registro['valor'] == 1) presentes++;
              }
            }
          }
        }
      }
      porcentajeAsistencias = total > 0 ? (presentes / total * 100) : 0;
    }

    // ---------- 4. TRAER NOTAS DE EXÁMENES ----------
    final notasRes = await http.get(
      Uri.parse(ApiRoutes.notasPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    List<Map<String, dynamic>> notasTemp = [];
    if (notasRes.statusCode == 200) {
      final notasJson = json.decode(notasRes.body);
      final notas = notasJson['notas'] as Map<String, dynamic>;
      notas.forEach((gestion, gestionVal) {
        final grados = gestionVal['grados'] as Map<String, dynamic>;
        grados.forEach((grado, gradoVal) {
          final periodos = gradoVal['periodos'] as Map<String, dynamic>;
          periodos.forEach((periodo, materias) {
            (materias as Map<String, dynamic>).forEach((materia, listaNotas) {
              for (var nota in (listaNotas as List)) {
                notasTemp.add({
                  "materia": materia,
                  "periodo": periodo,
                  "nota": nota['valor'] ?? 0,
                  "gestion": gestion,
                  "grado": grado,
                });
              }
            });
          });
        });
      });

      // -------- FILTRAR: Notas de exámenes SÓLO materias en curso y curso actual --------
      notasEnCurso = notasTemp
          .where((nota) =>
              nota['grado'].toString() == gradoActual &&
              nota['gestion'].toString() == gestionActual &&
              nombresMateriasEnCurso.contains(nota['materia']))
          .toList();

      // Lo demás, como histórico
      notasAntiguas = notasTemp
          .where((nota) => !(nota['grado'].toString() == gradoActual &&
              nota['gestion'].toString() == gestionActual &&
              nombresMateriasEnCurso.contains(nota['materia'])))
          .toList();
    }

    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 1,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
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
                          Icon(Icons.history_edu,
                              color: Colors.blue[700], size: 36),
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
                const SizedBox(height: 16),
                const Text(
                  "Resumen de desempeño",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ResumenCard(
                            title: "Promedio",
                            value: promedio.toStringAsFixed(1))),
                    SizedBox(width: 8),
                    Expanded(
                        child: ResumenCard(
                            title: "Asistencias",
                            value:
                                "${porcentajeAsistencias.toStringAsFixed(1)}%")),
                    SizedBox(width: 8),
                    Expanded(child: ResumenCard(title: "IA", value: nivelIA)),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  "Predicción de Rendimiento (IA)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                GraficoDesempeno(data: graficoMaterias),
                const SizedBox(height: 28),
                const Text(
                  "Notas de exámenes recientes (en curso)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                ...notasEnCurso.isEmpty
                    ? [
                        Text(
                          "No hay exámenes recientes para las materias actuales.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ]
                    : notasEnCurso
                        .map((nota) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(
                                    "${nota["materia"]} (${nota["periodo"]})"),
                                subtitle: Text(
                                    "Nota: ${nota["nota"]} — ${nota["grado"]} — ${nota["gestion"]}"),
                                leading: Icon(Icons.grade,
                                    color: Colors.blue[700], size: 28),
                              ),
                            ))
                        .toList(),
                if (notasAntiguas.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  const Text(
                    "Notas de exámenes anteriores",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ...notasAntiguas.map((nota) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title:
                              Text("${nota["materia"]} (${nota["periodo"]})"),
                          subtitle: Text(
                              "Nota: ${nota["nota"]} — ${nota["grado"]} — ${nota["gestion"]}"),
                          leading: Icon(Icons.history,
                              color: Colors.grey[600], size: 28),
                        ),
                      )),
                ]
              ],
            ),
    );
  }
}

// Asegúrate de que GraficoDesempeno recibe el parámetro 'data' como List<Map>
class GraficoDesempeno extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const GraficoDesempeno({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 40,
        alignment: Alignment.center,
        child: Text('Sin datos para graficar'),
      );
    }
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
                        child: Text(item["materia"].toString()),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (item["valor"] as num) / 100,
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
