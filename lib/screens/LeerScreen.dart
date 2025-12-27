import 'package:firebase_auth/firebase_auth.dart'; // 🔐 PARA OBTENER EL UID
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
 
class LeerScreen extends StatelessWidget {
  const LeerScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leer Producto"), centerTitle: true),
      body: lista(),
    );
  }
}
 
// =======================================================
// LISTA DE PRODUCTOS
// =======================================================
Widget lista() {
  // UID DEL USUARIO ACTUAL
  final String uidActual = FirebaseAuth.instance.currentUser!.uid;
 
  // 📡 Referencia a la tabla producto
  DatabaseReference ref = FirebaseDatabase.instance.ref('producto');
 
  return StreamBuilder<DatabaseEvent>(
    stream: ref.onValue,
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
        return const Center(child: Text("NO HAY DATA"));
      }
 
      final Map data = snapshot.data!.snapshot.value as Map;
 
      final List productos = [];
 
      data.forEach((key, value) {
        // =======================================================
        // se agregan productos
        // =======================================================
        if (value['uidUsuario'] == uidActual) {
          productos.add({
            'key': key, // ID  DE FIREBASE
            'codigo': value['codigo'],
            'nombre': value['nombre'],
            'precio': value['precio'],
            'cantidad': value['cantidad'],
            'descripcion': value['descripcion'],
            'imagen': value['imagen'],
          });
        }
      });
 
      if (productos.isEmpty) {
        return const Center(child: Text("No tienes productos registrados"));
      }
 
      return ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final item = productos[index];
 
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Image.network(
                item['imagen'],
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
              title: Text(item['nombre']),
              subtitle: Text(
                // CAMBIO CLAVE #3:
                // - Mostramos el código REAL del producto
                "Código: ${item['codigo']} | Precio: \$${item['precio']}",
              ),
              onTap: () => verProducto(context, item),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => editar(context, item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => eliminar(context, item),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
 
// =======================================================
// VER PRODUCTO
// =======================================================
void verProducto(BuildContext context, Map item) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(item['nombre']),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Código: ${item['codigo']}"),
            Text("Precio: \$ ${item['precio']}"),
            Text("Stock: ${item['cantidad']}"),
            const SizedBox(height: 8),
            Text(item['descripcion']),
            const SizedBox(height: 10),
            Image.network(
              item['imagen'],
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            ),
          ],
        ),
      ),
    ),
  );
}
 
// =======================================================
// EDITAR PRODUCTO
// =======================================================
void editar(BuildContext context, Map item) {
  final nombre = TextEditingController(text: item['nombre']);
  final precio = TextEditingController(text: item['precio'].toString());
  final cantidad = TextEditingController(text: item['cantidad'].toString());
  final descripcion = TextEditingController(text: item['descripcion']);
  final imagen = TextEditingController(text: item['imagen']);
 
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Editar Producto"),
      content: SingleChildScrollView(
        child: Column(
          children: [
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
              decoration: const InputDecoration(labelText: "Imagen URL"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("CANCELAR"),
        ),
        FilledButton(
          onPressed: () async {
            await FirebaseDatabase.instance
                // 🔑 AQUÍ ESTÁ EL CAMBIO IMPORTANTE
                .ref("producto/${item['key']}")
                .update({
                  "nombre": nombre.text,
                  "precio": precio.text,
                  "cantidad": cantidad.text,
                  "descripcion": descripcion.text,
                  "imagen": imagen.text,
                });
 
            Navigator.pop(context);
          },
          child: const Text("GUARDAR"),
        ),
      ],
    ),
  );
}
 
// =======================================================
// ELIMINAR PRODUCTO
// =======================================================
void eliminar(BuildContext context, Map item) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("¿Eliminar producto?"),
      content: Text("Eliminar ${item['nombre']}"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("NO"),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseDatabase.instance
                // 🔑 ID REAL DE FIREBASE
                .ref("producto/${item['key']}")
                .remove();
 
            Navigator.pop(context);
          },
          child: const Text("SÍ"),
        ),
      ],
    ),
  );
}
 