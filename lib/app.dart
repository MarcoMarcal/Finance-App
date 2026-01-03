import 'package:flutter/material.dart';

import 'screens/resumo_screen.dart';
import 'screens/adicionar_screen.dart';
import 'screens/registros_screen.dart';
import 'screens/configuracoes_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final screens = const [
    ResumoScreen(),
    AdicionarScreen(),
    RegistrosScreen(),
    ConfiguracoesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Resumo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Adicionar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Registros',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Configurações',
            ),
          ],
        ),
      ),
    );
  }
}
