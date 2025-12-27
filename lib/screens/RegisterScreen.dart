import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro")),
      body: formulario(context),
    );
  }
}
 
Widget formulario(context) {
  TextEditingController nombre = TextEditingController();
  TextEditingController apellido = TextEditingController();
  TextEditingController edad = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasenia = TextEditingController();
 
  return Column(
    children: [
      TextField(
        controller: nombre,
        decoration: InputDecoration(label: Text("Ingresar nombre")),
      ),
      TextField(
        controller: apellido,
        decoration: InputDecoration(label: Text("Ingresar apellido")),
      ),
      TextField(
        controller: edad,
        decoration: InputDecoration(label: Text("Ingresar edad")),
      ),
      TextField(
        controller: correo,
        decoration: InputDecoration(label: Text("Ingresar correo")),
      ),
 
      TextField(
        controller: contrasenia,
        obscureText: true,
        decoration: InputDecoration(label: Text("Ingresar contrasenia")),
      ),
 
      FilledButton(
        onPressed: () =>
            registro(context, nombre, apellido, edad, correo, contrasenia),
        child: Text("Registro"),
      ),
    ],
  );
}
 
Future<void> registro(
  context,
  nombre,
  apellido,
  edad,
  correo,
  contrasenia,
) async {
  try {
    // 1. Creamos el usuario
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: correo.text.trim(),
          password: contrasenia.text.trim(),
        );
 
    String uid = userCredential.user!.uid;
 
    // 2. Guardamos datos
    DatabaseReference ref = FirebaseDatabase.instance.ref("usuarios/$uid");
    await ref.set({
      "nombre": nombre.text,
      "apellido": apellido.text,
      "edad": edad.text,
      "correo": correo.text,
    });
 
    // 3. CERRAR SESIÓN para que no entre directo
    await FirebaseAuth.instance.signOut();
 
    // 4. Mostrar el diálogo (Simplemente borra el if(!context.mounted))
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Registro Exitoso"),
          content: const Text("Ahora inicia sesión con tu cuenta."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, "/login");
                Navigator.pop(context, "/login");
              },
              child: const Text("IR AL LOGIN"),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print("Error: $e");
  }
}
 