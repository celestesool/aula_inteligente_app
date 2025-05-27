// ignore_for_file: use_key_in_widget_constructors, use_super_parameters, depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EntregarTareaScreen extends StatefulWidget {
  final String titulo;
  final String materia;
  final String fechaEntrega;

  const EntregarTareaScreen({
    Key? key,
    required this.titulo,
    required this.materia,
    required this.fechaEntrega,
  }) : super(key: key);

  @override
  State<EntregarTareaScreen> createState() => _EntregarTareaScreenState();
}

class _EntregarTareaScreenState extends State<EntregarTareaScreen> {
  PlatformFile? archivoSeleccionado;
  bool _subiendo = false;

  Future<void> _seleccionarArchivo() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        archivoSeleccionado = result.files.first;
      });
    }
  }

  Future<void> _enviarEntrega() async {
    setState(() {
      _subiendo = true;
    });
    // Aquí deberías enviar el archivoSeleccionado al backend por HTTP (POST multipart)
    // y crear la EntregaTarea en la BD. Simulamos un éxito con Future.delayed:

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _subiendo = false;
    });

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Tarea entregada correctamente!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Tarea: ${widget.titulo}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text('Materia: ${widget.materia}'),
            const SizedBox(height: 10),
            Text('Fecha límite: ${widget.fechaEntrega}'),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Seleccionar Archivo'),
              onPressed: _subiendo ? null : _seleccionarArchivo,
            ),
            if (archivoSeleccionado != null) ...[
              const SizedBox(height: 12),
              Text("Archivo: ${archivoSeleccionado!.name}"),
            ],
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: _subiendo
                  ? const Text("Enviando...")
                  : const Text("Enviar Entrega"),
              onPressed: (_subiendo || archivoSeleccionado == null)
                  ? null
                  : _enviarEntrega,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
