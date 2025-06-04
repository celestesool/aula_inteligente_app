// ignore_for_file: use_super_parameters, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/materia.dart';
import '../../services/materia_service.dart';
import '../../providers/auth_provider.dart';

class MateriasScreen extends StatefulWidget {
  const MateriasScreen({Key? key}) : super(key: key);

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  List<Materia> materias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMateriasData();
  }

  Future<void> _loadMateriasData() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final usuario = auth.usuario;
    final token = auth.token; // <-- Esto es lo que te faltaba

    if (usuario == null || token == null || usuario.alumnoId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Llama al service con ambos argumentos
      final materiasList = await MateriaService().getMateriasPorAlumno(
        usuario.alumnoId!,
        token,
      );
      setState(() {
        materias = materiasList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final usuario = auth.usuario;

    if (usuario == null) {
      return _buildErrorScreen('Por favor inicia sesión');
    }
    if (usuario.alumnoId == null) {
      return _buildErrorScreen('Solo alumnos pueden ver materias');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Materias'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMateriasData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Materias'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (materias.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: materias.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final materia = materias[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              materia.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle:
                materia.descripcion != null && materia.descripcion.isNotEmpty
                    ? Text(materia.descripcion)
                    : null,
            leading: Icon(Icons.menu_book, color: Colors.blue[700], size: 32),
            onTap: () {
              // Aquí puedes navegar a la pantalla de detalle si la tienes
              // Navigator.push(...);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No tienes materias en curso',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadMateriasData,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
