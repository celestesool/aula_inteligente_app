// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class EditarFotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Solo mock no cambia la foto realmente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Función no implementada (solo visual)")),
        );
      },
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.edit, color: Colors.white, size: 18),
      ),
    );
  }
}
