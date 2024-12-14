import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaCiudades extends StatelessWidget {
  const ListaCiudades({super.key});

  Future<List<dynamic>> leerJsonExterno() async {
    const apiUrl = "https://jritsqmet.github.io/web-api/ciudades2.json";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['ciudades'];
    } else {
      throw Exception("Error al cargar ciudades: ${response.statusCode}");
    }
  }

  void mostrarMasDetalles(BuildContext context, Map<String, dynamic> ciudad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ciudad["nombre"]),
        content: Text(
          "Provincia: ${ciudad["provincia"]}\n"
          "Descripción: ${ciudad["descripcion"]}\n"
          "Población: ${ciudad["detalles"]["poblacion"]}\n"
          "Altitud: ${ciudad["detalles"]["altitud"]}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Ciudades")),
      body: FutureBuilder<List<dynamic>>(
        future: leerJsonExterno(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final ciudades = snapshot.data!;
            return ListView.builder(
              itemCount: ciudades.length,
              itemBuilder: (context, index) {
                final ciudad = ciudades[index];
                return ListTile(
                  leading: Image.network(
                    ciudad["informacion"]["imagen"],
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                  title: Text(ciudad["nombre"]),
                  subtitle: Text(ciudad["provincia"]),
                  onTap: () => mostrarMasDetalles(context, ciudad),
                );
              },
            );
          } else {
            return Center(child: Text('No se encontraron datos.'));
          }
        },
      ),
    );
  }
}
