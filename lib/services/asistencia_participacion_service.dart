// lib/services/asistencia_participacion_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../api_routes.dart';

class AsistenciaParticipacionService {
 Future<Map<String, dynamic>> getAsistencias(
      int alumnoId, String token) async {
    final res = await http.get(
      Uri.parse(ApiRoutes.asistenciasPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception("Error al obtener asistencias: ${res.body}");
    }
  }

  Future<Map<String, dynamic>> getParticipaciones(
      int alumnoId, String token) async {
    final res = await http.get(
      Uri.parse(ApiRoutes.participacionPorAlumno(alumnoId)),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception("Error al obtener participaciones: ${res.body}");
    }
  }
}
