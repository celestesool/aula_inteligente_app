class ApiRoutes {
  static const String baseUrl = 'http://192.168.145.65:5000';

  // --- AUTH ---
  static const String login = '$baseUrl/login';

  // --- ALUMNO: Perfil y Materias ---
  // Obtiene los datos del alumno (nombre, apellido, etc)
  static String perfilPorAlumno(int idAlumno) =>
      '$baseUrl/api/alumnos/$idAlumno';

  // Obtiene las materias inscritas agrupadas por gestión y grado
  // Ejemplo de uso: /api/alumnos/materias?alumno_id=3
  static String materiasPorAlumno(int idAlumno) =>
      '$baseUrl/api/alumnos/materias?alumno_id=$idAlumno';

  // --- NOTAS, ASISTENCIAS, PARTICIPACIONES ---
  // Todos por parámetro alumno_id
  static String notasPorAlumno(int idAlumno) =>
      '$baseUrl/api/alumnos/notas?alumno_id=$idAlumno';

  static String asistenciasPorAlumno(int idAlumno) =>
      '$baseUrl/api/alumnos/asistencias?alumno_id=$idAlumno';

  static String participacionPorAlumno(int idAlumno) =>
      '$baseUrl/api/alumnos/participacion?alumno_id=$idAlumno';
  // --- HISTORIAL Y PROMEDIOS ---
  static String historialAcademico(int idAlumno) =>
      '$baseUrl/api/alumnos/historial_academico?alumno_id=$idAlumno';

  static String promediosPorGrado(int idAlumno) =>
      '$baseUrl/api/alumnos/promedios?alumno_id=$idAlumno';

  // --- GRADOS Y MATERIAS POR GRADO ---
  static String gradosPorGestion = '$baseUrl/api/grados/agrupados';
  static String materiasPorGrado(int gestionId, int gradoId) =>
      '$baseUrl/api/grados/$gestionId/$gradoId/materias';
}
