// This is a basic Flutter widget test.
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aula_inteligente_app/app.dart'; 

void main() {
  testWidgets('App loads and builds AulaInteligenteApp',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AulaInteligenteApp());
    expect(find.text('Aula Inteligente'), findsOneWidget);
  });
}
