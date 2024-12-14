import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prueba_2/screens/gastronomia_screen.dart';
import 'package:prueba_2/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Campos Vacíos'),
          content: Text('Rellene todos los campos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GastronomiaScreen()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error de Autenticación'),
          content: Text(describeFirebaseAuthError(e)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  String describeFirebaseAuthError(Object error) {
    if (error.toString().contains('user-not-found')) {
      return 'credenciales incorrectas';
    } else if (error.toString().contains('wrong-password')) {
      return 'Contraseña incorrecta';
    } else {
      return 'Ocurrió un error inesperado, intente más tarde';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Inicio de Sesión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Ingresar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroScreen()),
                );
              },
              child: Text('No tienes cuenta? Regístrate aquí!'),
            ),
          ],
        ),
      ),
    );
  }
}
