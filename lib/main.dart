import 'package:flutter/material.dart';
// FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'package:prueba_2/screens/welcome_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BienvenidaScreen(), 
    );
  }
}
