class Usuario {
  final int id;
  final String nombreUsuario;
  final String correo;
  final String rol;
  final int? alumnoId; // Ojo: puede ser null si el usuario no es alumno
  final String? nombreCompleto;

  Usuario({
    required this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.rol,
    required this.alumnoId,
    this.nombreCompleto,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'],
        nombreUsuario: json['nombre_usuario'],
        correo: json['correo'],
        rol: json['rol'],
        alumnoId: json['alumno_id'], 
        nombreCompleto: json['nombre_completo'],
      );
}
