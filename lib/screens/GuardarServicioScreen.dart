import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
 
class GuardarServicioScreen extends StatelessWidget {
  const GuardarServicioScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guardar Servicio")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: formulario(context),
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
 
  return SingleChildScrollView(
    child: Column(
      children: [
        TextField(
          controller: codigo,
          decoration: const InputDecoration(labelText: "Código del producto"),
        ),
        TextField(
          controller: nombre,
          decoration: const InputDecoration(labelText: "Nombre"),
        ),
        TextField(
          controller: precio,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Precio"),
        ),
        TextField(
          controller: cantidad,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Cantidad"),
        ),
        TextField(
          controller: descripcion,
          decoration: const InputDecoration(labelText: "Descripción"),
        ),
        TextField(
          controller: imagen,
          decoration: const InputDecoration(labelText: "URL de la imagen"),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => guardarProducto(
            context,
            codigo,
            nombre,
            precio,
            cantidad,
            descripcion,
            imagen,
          ),
          child: const Text("Guardar Producto"),
        ),
      ],
    ),
  );
}
 
Future<void> guardarProducto(
  BuildContext context,
  TextEditingController codigo,
  TextEditingController nombre,
  TextEditingController precio,
  TextEditingController cantidad,
  TextEditingController descripcion,
  TextEditingController imagen,
) async {
  try {
    // UID DEL USUARIO LOGUEADO
    final user = FirebaseAuth.instance.currentUser;
 
    if (user == null) {
      throw Exception("Usuario no autenticado");
    }
 
    // Firebase genera la CLAVE
    DatabaseReference ref = FirebaseDatabase.instance.ref("producto").push();
 
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
        content: Text("Producto guardado correctamente"),
        backgroundColor: Colors.green,
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
      SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
    );
  }
}
 