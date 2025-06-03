// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, use_super_parameters, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;

void _login() async {
    setState(() => _loading = true);
    try {
      final res = await _authService.login(
        _userController.text.trim(),
        _passController.text.trim(),
      );
      setState(() => _loading = false);

      if (res != null && res['token'] != null && res['usuario'] != null) {
        final usuario = Usuario.fromJson(res['usuario']);

        // Solo dejar entrar a alumnos
        if (usuario.rol.toLowerCase() != 'alumno') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Solo los alumnos pueden iniciar sesión en la app.')),
          );
          return;
        }

        Provider.of<AuthProvider>(context, listen: false)
            .setAuth(usuario, res['token']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bienvenido 👋')),
        );
        // Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, color: Colors.blue[700], size: 72),
                const SizedBox(height: 20),
                const Text(
                  'Aula Inteligente',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Ingresar'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
