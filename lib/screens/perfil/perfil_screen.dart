// lib/screens/perfil/perfil_screen.dart
// ignore_for_file: use_super_parameters, unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../api_routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String? nombreCompleto;
  String? cursoActual;
  List<Map<String, dynamic>> materiasEnCurso = [];
  List<Map<String, dynamic>> materiasAprobadas = [];
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

    // Traer nombre completo
    final perfilRes = await http.get(
      Uri.parse(ApiRoutes.perfilPorAlumno(usuario.alumnoId!)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (perfilRes.statusCode == 200) {
      final perfil = json.decode(perfilRes.body);
      nombreCompleto = "${perfil['nombre']} ${perfil['apellido']}";
    } else {
      nombreCompleto = usuario.nombreUsuario;
    }

    // Traer materias
    final materiasRes = await http.get(
      Uri.parse(ApiRoutes.materiasPorAlumno(usuario.alumnoId!)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (materiasRes.statusCode == 200) {
      final jsonResp = json.decode(materiasRes.body);
      final materiasPorGestion = jsonResp['materias_por_gestion'] as List;
      final enCurso = <Map<String, dynamic>>[];
      final aprobadas = <Map<String, dynamic>>[];

      // Para identificar el curso actual (el grado y gestión más reciente en curso)
      String? ultimoGrado, ultimoGestion;

      for (final x in materiasPorGestion) {
        final gestion = x['gestion'].toString();
        final grado = x['grado'].toString();
        final estado = x['estado'];
        final materias = x['materias'] as List;
        for (final m in materias) {
          final data = {
            'nombre': m['nombre'],
            'gestion': gestion,
            'grado': grado,
          };
          if (estado == 'en curso') {
            enCurso.add(data);
            // Tomar el último curso en curso
            ultimoGestion = gestion;
            ultimoGrado = grado;
          } else if (estado == 'aprobado') {
            aprobadas.add(data);
          }
        }
      }

      // Filtrar últimas materias aprobadas por nombre (solo la de mayor gestión y grado)
      Map<String, Map<String, dynamic>> ultimasAprobadas = {};
      for (var m in aprobadas) {
        final nombre = m['nombre'];
        final key =
            "$nombre"; // Puedes agregar grado o gestion si necesitas distinguir más
        // Si no existe o es más reciente, reemplaza
        if (!ultimasAprobadas.containsKey(key) ||
            _compareCurso(m, ultimasAprobadas[key]!) > 0) {
          ultimasAprobadas[key] = m;
        }
      }

      setState(() {
        cursoActual = (ultimoGrado != null && ultimoGestion != null)
            ? "$ultimoGrado — $ultimoGestion"
            : null;
        materiasEnCurso = enCurso;
        materiasAprobadas = ultimasAprobadas.values.toList();
        cargando = false;
      });
    } else {
      setState(() {
        cargando = false;
      });
    }
  }

  /// Compara dos cursos por gestión y grado, retorna 1 si a > b, -1 si a < b, 0 si igual
  int _compareCurso(Map<String, dynamic> a, Map<String, dynamic> b) {
    final ag = a['grado'] ?? '';
    final bg = b['grado'] ?? '';
    final ay = int.tryParse(a['gestion'].toString()) ?? 0;
    final by = int.tryParse(b['gestion'].toString()) ?? 0;
    if (ay != by) return ay.compareTo(by);
    return ag.compareTo(bg);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final usuario = auth.usuario!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
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
              child: const Icon(Icons.person, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              nombreCompleto ?? usuario.nombreUsuario,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(child: Text(usuario.correo)),
          if (cursoActual != null) ...[
            const SizedBox(height: 14),
            Center(
              child: Text(
                "Curso actual: $cursoActual",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          const Divider(height: 35),
          const Text(
            "Materias inscritas (en curso):",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (cargando)
            const Center(child: CircularProgressIndicator())
          else if (materiasEnCurso.isEmpty)
            const Text('No hay materias en curso.')
          else
            Column(
              children: materiasEnCurso
                  .map((m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 18, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(m['nombre']),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          if (!cargando && materiasAprobadas.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              "Materias aprobadas (última vez):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: materiasAprobadas
                  .map((m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.verified,
                                size: 18, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              "${m['nombre']} (${m['grado']} — ${m['gestion']})",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ]
        ],
      ),
    );
  }
}
