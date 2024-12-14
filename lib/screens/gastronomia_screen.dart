import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:prueba_2/screens/lista_ciudades_screen.dart';


class GastronomiaScreen extends StatefulWidget {
  @override
  GastronomiaScreenState createState() => GastronomiaScreenState();
}

class GastronomiaScreenState extends State<GastronomiaScreen> {
  int currentIndex = 0;
  final idController = TextEditingController();
  final platoController = TextEditingController();
  final ciudadController = TextEditingController();
  final database = FirebaseDatabase.instance.ref("platillos");

  void guardarPlatillo() {
    if ([idController, platoController, ciudadController]
        .any((controller) => controller.text.isEmpty)) {
      mostrarMensaje('complete todos los campos');
      return;
    }

    database.push().set({
      "id": idController.text,
      "nombre": platoController.text,
      "ciudad": ciudadController.text,
    });

    mostrarMensaje('guardado');
    [idController, platoController, ciudadController].forEach((c) => c.clear());
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guia turistica de Ecuador'),
      ),
      body: currentIndex == 0
          ? pantallaGastronomia()
          : ListaCiudades(), 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Gastronomía',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Ciudades',
          ),
        ],
      ),
    );
  }

  Widget pantallaGastronomia() {
    return Padding(
      padding:  EdgeInsets.all(16.0),
      child: Column(
        children: [
          campoTexto(idController, 'ID'),
          campoTexto(platoController, 'Plato'),
          campoTexto(ciudadController, 'Ciudad'),
          ElevatedButton(
            onPressed: guardarPlatillo,
            child:  Text('Guardar'),
          ),
          const Divider(),
          const Text(
            'Lista de platos guardados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(child: listaPlatillos()),
        ],
      ),
    );
  }

  Widget listaPlatillos() {
    return StreamBuilder(
      stream: database.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final data = (snapshot.data as DatabaseEvent?)?.snapshot.value as Map?;
        if (data == null) {
          return  Center(child: Text('No hay platos guardados'));
        }
        return ListView(
          children: data.values
              .map((platillo) => ListTile(
                    title: Text(platillo['nombre']),
                    subtitle: Text('Ciudad: ${platillo['ciudad']}'),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget campoTexto(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
