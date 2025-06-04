import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/materia.dart';
import '../api_routes.dart';

class MateriaService {
  Future<List<Materia>> getMateriasPorAlumno(int alumnoId, String token) async {
    final url = Uri.parse(ApiRoutes.materiasPorAlumno(alumnoId));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Materia> materiasEnCurso = [];
      if (data['materias_por_gestion'] != null) {
        for (var gestion in data['materias_por_gestion']) {
          if (gestion['estado'] == 'en curso') {
            final materiasList = gestion['materias'] as List;
            materiasEnCurso
                .addAll(materiasList.map((e) => Materia.fromJson(e)));
          }
        }
      }
      return materiasEnCurso;
    }
    throw Exception('Error al obtener materias');
  }
}
