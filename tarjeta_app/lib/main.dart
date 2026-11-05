import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
      ),
      home: const TarjetaScreen(),
    );
  }
}

class TarjetaScreen extends StatefulWidget {
  const TarjetaScreen({super.key});

  @override
  State<TarjetaScreen> createState() => _TarjetaScreenState();
}

class _TarjetaScreenState extends State<TarjetaScreen> {
  bool _fondoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondoOscuro ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        title: const Text('Mi tarjeta'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            const SizedBox(height: 20),
            Text(
              'Lucas Coronado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _fondoOscuro ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Técnico en Informática',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: Text(
                'Fondo oscuro',
                style: TextStyle(
                  color: _fondoOscuro ? Colors.white : Colors.black,
                ),
              ),
              value: _fondoOscuro,
              onChanged: (bool valor) {
                setState(() {
                  _fondoOscuro = valor;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Hola!')),
                );
              },
              child: const Text('Saludar'),
            ),
          ],
        ),
      ),
    );
  }
}
