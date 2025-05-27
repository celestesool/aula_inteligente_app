// ignore_for_file: use_key_in_widget_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'entregar_tarea_screen.dart';

class TareaDetalleScreen extends StatefulWidget {
  final String titulo;
  final String descripcion;
  final String materia;
  final String fechaEntrega;
  final bool entregada;
  final String? archivoUrl;
  final double? calificacion;

  const TareaDetalleScreen({
    Key? key,
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.fechaEntrega,
    required this.entregada,
    this.archivoUrl,
    this.calificacion,
  }) : super(key: key);

  @override
  State<TareaDetalleScreen> createState() => _TareaDetalleScreenState();
}

class _TareaDetalleScreenState extends State<TareaDetalleScreen> {
  late bool _entregada;

  @override
  void initState() {
    super.initState();
    _entregada = widget.entregada;
  }

  void _refreshAfterEntrega() {
    setState(() {
      _entregada = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text('Título:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.titulo, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Materia:', style: Theme.of(context).textTheme.titleMedium),
            Text(widget.materia),
            const SizedBox(height: 16),
            Text('Descripción:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(widget.descripcion.isNotEmpty
                ? widget.descripcion
                : 'Sin descripción'),
            const SizedBox(height: 16),
            Text('Fecha de entrega:',
                style: Theme.of(context).textTheme.titleMedium),
            Text(widget.fechaEntrega),
            const SizedBox(height: 24),
            Text('Estado:', style: Theme.of(context).textTheme.titleMedium),
            Text(_entregada ? 'Entregada' : 'Pendiente',
                style: TextStyle(
                  color: _entregada ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                )),
            if (!_entregada) ...[
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Entregar Tarea"),
                onPressed: () async {
                  final entregadaAhora = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EntregarTareaScreen(
                        titulo: widget.titulo,
                        materia: widget.materia,
                        fechaEntrega: widget.fechaEntrega,
                      ),
                    ),
                  );
                  if (entregadaAhora == true) {
                    _refreshAfterEntrega();
                  }
                },
              ),
            ],
            if (_entregada) ...[
              const SizedBox(height: 16),
              const Text('Archivo entregado:'),
              Text(widget.archivoUrl ?? 'Archivo subido'),
              // Calificación si existe
              if (widget.calificacion != null) ...[
                const SizedBox(height: 8),
                Text('Calificación: ${widget.calificacion}'),
              ]
            ]
          ],
        ),
      ),
    );
  }
}
