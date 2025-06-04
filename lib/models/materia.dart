// models/materia.dart

class Materia {
  final int id;
  final String nombre;
  final String descripcion;

  Materia({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory Materia.fromJson(Map<String, dynamic> json) => Materia(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'] ?? '',
      );

  get docente => null;

  get periodo => null;
}

class MateriasPorGrado {
  final int gestion;
  final String grado;
  final String estado;
  final List<Materia> materias;

  MateriasPorGrado({
    required this.gestion,
    required this.grado,
    required this.estado,
    required this.materias,
  });

  factory MateriasPorGrado.fromJson(Map<String, dynamic> json) =>
      MateriasPorGrado(
        gestion: json['gestion'],
        grado: json['grado'],
        estado: json['estado'],
        materias:
            (json['materias'] as List).map((m) => Materia.fromJson(m)).toList(),
      );
}
