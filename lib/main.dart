import 'package:flutter/material.dart';
import 'screens/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',

      theme: ThemeData(
        useMaterial3: true,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 99, 1, 1),
          foregroundColor: Color.fromARGB(255, 255, 254, 188),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 255, 165, 0),
          foregroundColor: Color.fromARGB(255, 255, 255, 255),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: Menu(),
    );
  }
}
