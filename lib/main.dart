
import 'package:app_crud/screens/GuardarServicioScreen.dart';
import 'package:app_crud/screens/MostrarServicioScreen.dart';
import 'package:app_crud/screens/LoginScreen.dart';
import 'package:app_crud/screens/RegisterScreen.dart';
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
      
      routes: {
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/guardarServicio": (context) => GuardarServicioScreen(),
        "/mostrarServicio": (context) => MostrarservicioScreen(),
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
        title: Text("Servicios"),
        actions: [
          FilledButton(onPressed: () => FirebaseAuth.instance.signOut(), child:Text("Salir"))
          
        ]
      ),
      body: Column(
        children: [
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, "/mostrarServicio"),
            child: Text("Mostrar Servicio"),
          ),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, "/guardarServicio"),
            child: Text("Guardar Servicio"),
          ),
        ],
      ),
    );
  }
}