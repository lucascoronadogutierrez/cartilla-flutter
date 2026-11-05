import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tasks_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seccion = 0;

  final List<String> _titulos = ['Inicio', 'Tareas', 'Perfil'];

  final List<Widget> _pantallas = const [
    InicioScreen(),
    TareasScreen(),
    PerfilScreen(),
  ];

  void _irASeccion(int indice) {
    Navigator.pop(context);
    setState(() => _seccion = indice);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
              title: const Text('Tareas'),
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
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: _pantallas[_seccion],
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

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${state.pendientes}',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
          const Text('tareas pendientes'),
          const SizedBox(height: 16),
          Text('${state.completadas} completadas'),
        ],
      ),
    );
  }
}

class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController _tituloCtrl = TextEditingController();
  String _prioridad = 'media';

  @override
  void dispose() {
    _tituloCtrl.dispose();
    super.dispose();
  }

  Color _colorPrioridad(String prioridad) {
    if (prioridad == 'alta') return Colors.red;
    if (prioridad == 'media') return Colors.orange;
    return Colors.blue;
  }

  void _agregar() {
    String titulo = _tituloCtrl.text.trim();
    if (titulo.isEmpty) return;
    ref.read(tasksProvider.notifier).agregar(titulo, _prioridad);
    _tituloCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tituloCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nueva tarea',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _agregar(),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _prioridad,
                items: const [
                  DropdownMenuItem(value: 'alta', child: Text('Alta')),
                  DropdownMenuItem(value: 'media', child: Text('Media')),
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                ],
                onChanged: (String? valor) {
                  setState(() => _prioridad = valor ?? 'media');
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _agregar,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.tareas.length,
            itemBuilder: (context, i) {
              final tarea = state.tareas[i];
              return ListTile(
                leading: Checkbox(
                  value: tarea.completada,
                  onChanged: (_) {
                    ref.read(tasksProvider.notifier).toggleCompletada(i);
                  },
                ),
                title: Text(
                  tarea.titulo,
                  style: TextStyle(
                    decoration:
                        tarea.completada ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text('Prioridad: ${tarea.prioridad}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 14,
                      color: _colorPrioridad(tarea.prioridad),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ref.read(tasksProvider.notifier).eliminar(i);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 50, child: Text('LC', style: TextStyle(fontSize: 32))),
          SizedBox(height: 16),
          Text(
            'Lucas Coronado',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
