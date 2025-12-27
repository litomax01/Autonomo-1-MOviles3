import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GuardarServicioScreen extends StatelessWidget {
  const GuardarServicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Guardar Servicio"),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: formulario(context),
          ),
        ),
      ),
    );
  }
}

Widget formulario(BuildContext context) {
  final TextEditingController codigo = TextEditingController();
  final TextEditingController nombre = TextEditingController();
  final TextEditingController precio = TextEditingController();
  final TextEditingController cantidad = TextEditingController();
  final TextEditingController descripcion = TextEditingController();
  final TextEditingController imagen = TextEditingController();

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "Nuevo Servicio",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),

      TextField(
        controller: codigo,
        decoration: const InputDecoration(labelText: "Código"),
      ),
      const SizedBox(height: 8),

      TextField(
        controller: nombre,
        decoration: const InputDecoration(labelText: "Nombre"),
      ),
      const SizedBox(height: 8),

      TextField(
        controller: precio,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Precio"),
      ),
      const SizedBox(height: 8),

      TextField(
        controller: cantidad,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Cantidad"),
      ),
      const SizedBox(height: 8),

      TextField(
        controller: descripcion,
        decoration: const InputDecoration(labelText: "Descripción"),
      ),
      const SizedBox(height: 8),

      TextField(
        controller: imagen,
        decoration: const InputDecoration(labelText: "URL Imagen"),
      ),
      const SizedBox(height: 20),

      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.amber[700],
          foregroundColor: Colors.black,
        ),
        onPressed: () => guardarServicio(
          context,
          codigo,
          nombre,
          precio,
          cantidad,
          descripcion,
          imagen,
        ),
        child: const Text("Guardar"),
      ),
    ],
  );
}

Future<void> guardarServicio(
  BuildContext context,
  TextEditingController codigo,
  TextEditingController nombre,
  TextEditingController precio,
  TextEditingController cantidad,
  TextEditingController descripcion,
  TextEditingController imagen,
) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuario no autenticado");
    }

    DatabaseReference ref =
        FirebaseDatabase.instance.ref("servicio").push();

    await ref.set({
      "codigo": codigo.text.trim(),
      "nombre": nombre.text.trim(),
      "precio": precio.text.trim(),
      "cantidad": cantidad.text.trim(),
      "descripcion": descripcion.text.trim(),
      "imagen": imagen.text.trim(),
      "uidUsuario": user.uid,
      "emailUsuario": user.email,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Servicio guardado correctamente"),
      ),
    );

    codigo.clear();
    nombre.clear();
    precio.clear();
    cantidad.clear();
    descripcion.clear();
    imagen.clear();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
      ),
    );
  }
}
