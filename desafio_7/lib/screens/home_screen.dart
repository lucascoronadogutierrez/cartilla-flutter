import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'tareas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  Widget _pantallaActual() {
    if (_seccion == 0) return const _InicioScreen();
    if (_seccion == 1) return const TareasScreen();
    return const _PerfilScreen();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final String email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_seccion])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.person, color: cs.onPrimaryContainer),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: TextStyle(color: cs.onPrimary, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _seccion = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Tareas'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _seccion = 1);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                Navigator.pop(context);
                await cerrarSesion();
              },
            ),
          ],
        ),
      ),
      body: _pantallaActual(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int i) => setState(() => _seccion = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _InicioScreen extends StatelessWidget {
  const _InicioScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Bienvenido a tu app de tareas', style: TextStyle(fontSize: 18)),
    );
  }
}

class _PerfilScreen extends StatelessWidget {
  const _PerfilScreen();

  @override
  Widget build(BuildContext context) {
    final String email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 16),
          Text(email, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
