import 'package:flutter/material.dart';
import '../../data/local/local_database.dart';
import '../../domain/entities/tarea.dart';
import 'configuracion_screen.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final LocalDatabase _db = LocalDatabase();
  final TextEditingController _tituloCtrl = TextEditingController();
  List<Tarea> _tareas = [];
  String _filtro = 'todas';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final lista = await _db.obtenerTodas();
    if (mounted) {
      setState(() => _tareas = lista);
    }
  }

  Future<void> _agregar() async {
    String titulo = _tituloCtrl.text.trim();
    if (titulo.isEmpty) return;
    await _db.insertar(
      Tarea(titulo: titulo, fecha: DateTime.now().toIso8601String()),
    );
    _tituloCtrl.clear();
    await _cargar();
  }

  Future<void> _toggle(Tarea tarea) async {
    await _db.actualizar(tarea.copyWith(completada: !tarea.completada));
    await _cargar();
  }

  Future<void> _eliminar(Tarea tarea) async {
    setState(() => _tareas.removeWhere((t) => t.id == tarea.id));
    await _db.eliminar(tarea.id!);
  }

  List<Tarea> _tareasVisibles() {
    if (_filtro == 'pendientes') {
      return _tareas.where((t) => !t.completada).toList();
    }
    if (_filtro == 'completadas') {
      return _tareas.where((t) => t.completada).toList();
    }
    return _tareas;
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _tareasVisibles();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConfiguracionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
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
                ElevatedButton(
                  onPressed: _agregar,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Todas'),
                selected: _filtro == 'todas',
                onSelected: (_) => setState(() => _filtro = 'todas'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Pendientes'),
                selected: _filtro == 'pendientes',
                onSelected: (_) => setState(() => _filtro = 'pendientes'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Completadas'),
                selected: _filtro == 'completadas',
                onSelected: (_) => setState(() => _filtro = 'completadas'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: visibles.length,
              itemBuilder: (context, index) {
                final tarea = visibles[index];
                return Dismissible(
                  key: ValueKey(tarea.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _eliminar(tarea),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: (_) => _toggle(tarea),
                    ),
                    title: Text(
                      tarea.titulo,
                      style: TextStyle(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
