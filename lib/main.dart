import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Librería para conectar ViewModel con Vistas
import 'viewmodels/stations_viewmodel.dart';
import 'views/home_screen.dart';

void main() {
  
  runApp(const AppState());
}


class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider(create: (_) => StationsViewModel()),
      ],
      child: const MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quitamos la etiqueta "Debug"
      title: 'BiciCoruña',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 102, 60, 255)),
        useMaterial3: true,
      ),
      
      home: const HomeScreen(),
    );
  }
}

//commit desde vscode

     