import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MostrarservicioScreen extends StatelessWidget {
  const MostrarservicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Mis servicios"),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: lista(context),
      ),
    );
  }
}

Widget lista(BuildContext context) {
  final String uidActual = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference ref = FirebaseDatabase.instance.ref('servicio');

  return StreamBuilder<DatabaseEvent>(
    stream: ref.onValue,
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
        return const Center(child: Text("No hay servicios"));
      }

      final Map data = snapshot.data!.snapshot.value as Map;
      final List servicios = [];

      data.forEach((key, value) {
        if (value['uidUsuario'] == uidActual) {
          servicios.add({
            'key': key,
            'codigo': value['codigo'],
            'nombre': value['nombre'],
            'precio': value['precio'],
            'cantidad': value['cantidad'],
            'descripcion': value['descripcion'],
            'imagen': value['imagen'],
          });
        }
      });

      if (servicios.isEmpty) {
        return const Center(child: Text("No tienes servicios registrados"));
      }

      return ListView.builder(
        itemCount: servicios.length,
        itemBuilder: (context, index) {
          final item = servicios[index];

          return Card(
            color: Colors.white,
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        item['imagen'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item['nombre'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Text("Código: ${item['codigo']}"),
                  Text("Precio: \$${item['precio']}"),
                  Text("Stock: ${item['cantidad']}"),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        color: Colors.amber[700],
                        icon: const Icon(Icons.visibility),
                        onPressed: () => verServicio(context, item),
                      ),
                      IconButton(
                        color: Colors.amber[700],
                        icon: const Icon(Icons.edit),
                        onPressed: () => editar(context, item),
                      ),
                      IconButton(
                        color: Colors.red[400],
                        icon: const Icon(Icons.delete),
                        onPressed: () => eliminar(context, item),
                      ),
                    ],
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

void verServicio(BuildContext context, Map item) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(item['nombre']),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Código: ${item['codigo']}"),
            Text("Precio: \$${item['precio']}"),
            Text("Cantidad: ${item['cantidad']}"),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
      ],
    ),
  );
}

void editar(BuildContext context, Map item) {
  final nombre = TextEditingController(text: item['nombre']);
  final precio = TextEditingController(text: item['precio'].toString());
  final cantidad = TextEditingController(text: item['cantidad'].toString());
  final descripcion = TextEditingController(text: item['descripcion']);
  final imagen = TextEditingController(text: item['imagen']);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Editar servicio"),
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
          child: const Text("Cancelar"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            await FirebaseDatabase.instance
                .ref("producto/${item['key']}")
                .update({
              "nombre": nombre.text.trim(),
              "precio": precio.text.trim(),
              "cantidad": cantidad.text.trim(),
              "descripcion": descripcion.text.trim(),
              "imagen": imagen.text.trim(),
            });

            Navigator.pop(context);
          },
          child: const Text("Guardar"),
        ),
      ],
    ),
  );
}

void eliminar(BuildContext context, Map item) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Eliminar"),
      content: const Text("¿Deseas eliminar este servicio?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("No"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red[400],
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await FirebaseDatabase.instance
                .ref("servicio/${item['key']}")
                .remove();
            Navigator.pop(context);
          },
          child: const Text("Sí"),
        ),
      ],
    ),
  );
}
