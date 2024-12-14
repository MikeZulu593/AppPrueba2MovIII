import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          //F O N D O
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),
          //INICIA CONTENIDO//
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Guía Turística de Ecuador',
                style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Enzo Nieto - MikeZulu593',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistroScreen()),
                  );
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
