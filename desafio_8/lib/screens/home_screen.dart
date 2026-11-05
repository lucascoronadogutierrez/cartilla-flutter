import 'package:flutter/material.dart';
import 'asistencias_screen.dart';
import 'escaneo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _seccion == 0 ? const EscaneoScreen() : const AsistenciasScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int i) => setState(() => _seccion = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escanear',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Asistencias',
          ),
        ],
      ),
    );
  }
}
