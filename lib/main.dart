
import 'package:app_crud/screens/GuardarScreen.dart';
import 'package:app_crud/screens/LeerScreen.dart';
import 'package:app_crud/screens/LoginScreen.dart';
import 'package:app_crud/screens/RegistroScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MiAplicacion());
}
 
class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //rutas
      routes: {
        "/login": (context) => LoginScreen(),
        "/registro": (context) => RegistroScreen(),
        "/guardarProducto": (context) => GuardarScreen(),
        "/leerProducto": (context) => LeerScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return const Cuerpo();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
 
class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        actions: [
          // Botón para cerrar sesión
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, "/leerProducto"),
            child: Text("Leer Producto"),
          ),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, "/guardarProducto"),
            child: Text("Guardar Producto"),
          ),
        ],
      ),
    );
  }
}