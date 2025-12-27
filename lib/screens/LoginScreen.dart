import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraseniaController = TextEditingController();

  @override
  void dispose() {
    correoController.dispose();
    contraseniaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: correoController,
              decoration: const InputDecoration(
                labelText: "Ingresar correo",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contraseniaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Ingresar contraseña",
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: login,
              icon: const Icon(Icons.login),
              label: const Text("Ingresar"),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, "/registro"),
              icon: const Icon(Icons.person_add),
              label: const Text("Regístrate"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correoController.text.trim(),
        password: contraseniaController.text,
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = "Ocurrió un error inesperado";

      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        mensaje = 'El correo o la contraseña no son correctos.';
      } else if (e.code == 'wrong-password') {
        mensaje = 'Contraseña incorrecta.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El formato del correo es inválido.';
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error de inicio de sesión"),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Aceptar"),
            ),
          ],
        ),
      );
    }
  }
}
