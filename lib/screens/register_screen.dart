import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistroScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> register(BuildContext context) async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Campos incompletos'),
          content: Text('Complete todos los campos para registrarse.'),
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

    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Las contraseñas no coinciden.'),
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text('Éxito'),
          content:  Text('Usuario registrado con éxito.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              ),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text('Error de Registro'),
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
    if (error.toString().contains('email-already-in-use')) {
      return 'El usuario ya se encuentra registrado';
    } else if (error.toString().contains('weak-password')) {
      return 'La contraseña debe tener 8 caracteres como mínimo';
    } else {
      return 'Ocurrio un error inesperado, intenta de nuevo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Crea una cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: emailController,
              decoration:  InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration:  InputDecoration(labelText: 'Contraseña'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: 'Confirmar Contraseña'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => register(context),
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
