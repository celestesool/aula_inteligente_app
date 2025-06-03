import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_routes.dart';

// Solo funciones de fetch, no necesitas modelos
class HistorialService {
  static Future<Map<String, dynamic>> getNotas(int alumnoId, String token) async {
    final res = await http.get(
      Uri.parse(ApiRoutes.notasPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception("Error al obtener notas: ${res.body}");
    }
  }

  static Future<Map<String, dynamic>> getAsistencias(
      int alumnoId, String token) async {
    final res = await http.get(
      Uri.parse(ApiRoutes.asistenciasPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception("Error al obtener asistencias: ${res.body}");
    }
  }

  static Future<Map<String, dynamic>> getParticipacion(
      int alumnoId, String token) async {
    final res = await http.get(
      Uri.parse(ApiRoutes.participacionPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception("Error al obtener participación: ${res.body}");
    }
  }
}
