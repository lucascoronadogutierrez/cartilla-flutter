import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _modoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.purple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        modoOscuro: _modoOscuro,
        onCambiarTema: (bool valor) {
          setState(() {
            _modoOscuro = valor;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) onCambiarTema;

  const HomeScreen({
    super.key,
    required this.modoOscuro,
    required this.onCambiarTema,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  Widget _pantallaActual() {
    if (_seccion == 0) return const InicioScreen();
    if (_seccion == 1) return const TareasScreen();
    return const PerfilScreen();
  }

  void _irASeccion(int indice) {
    Navigator.pop(context);
    setState(() => _seccion = indice);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_seccion]),
      ),
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
                    child: Text(
                      'LC',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Lucas Coronado',
                    style: TextStyle(color: cs.onPrimary, fontSize: 16),
                  ),
                  Text(
                    'lucas@email.com',
                    style: TextStyle(color: cs.onPrimary, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: _seccion == 0,
              onTap: () => _irASeccion(0),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Mis Tareas'),
              selected: _seccion == 1,
              onTap: () => _irASeccion(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              selected: _seccion == 2,
              onTap: () => _irASeccion(2),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfiguracionScreen(
                      modoOscuro: widget.modoOscuro,
                      onCambiarTema: widget.onCambiarTema,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text('Cerrar sesión', style: TextStyle(color: cs.error)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: _pantallaActual(),
      floatingActionButton: _seccion == 1
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (int indice) {
          setState(() => _seccion = indice);
        },
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

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  Widget _estadistica(BuildContext context, String numero, String texto) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              numero,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: cs.onSecondaryContainer,
              ),
            ),
            Text(texto, style: TextStyle(color: cs.onSecondaryContainer)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, Lucas!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Estas son tus estadísticas de hoy',
                  style: TextStyle(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _estadistica(context, '3', 'Pendientes'),
              _estadistica(context, '7', 'Completadas'),
              _estadistica(context, '10', 'Total'),
            ],
          ),
        ],
      ),
    );
  }
}

class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> tareas = [
      'Estudiar Dart',
      'Hacer el desafío 3',
      'Subir el código a GitHub',
      'Leer la documentación de Flutter',
    ];

    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(tareas[index]),
        );
      },
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: cs.primaryContainer,
            child: Text(
              'LC',
              style: TextStyle(fontSize: 32, color: cs.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lucas Coronado',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text('Técnico en Informática'),
        ],
      ),
    );
  }
}

class ConfiguracionScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) onCambiarTema;

  const ConfiguracionScreen({
    super.key,
    required this.modoOscuro,
    required this.onCambiarTema,
  });

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  late bool _oscuro;

  @override
  void initState() {
    super.initState();
    _oscuro = widget.modoOscuro;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambia entre tema claro y oscuro'),
            value: _oscuro,
            onChanged: (bool valor) {
              setState(() => _oscuro = valor);
              widget.onCambiarTema(valor);
            },
          ),
        ],
      ),
    );
  }
}
