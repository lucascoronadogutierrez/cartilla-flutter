import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/tareas_service.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TextEditingController _tituloCtrl = TextEditingController();

  @override
  void dispose() {
    _tituloCtrl.dispose();
    super.dispose();
  }

  void _agregar() {
    String titulo = _tituloCtrl.text.trim();
    if (titulo.isEmpty) return;
    agregarTarea(titulo);
    _tituloCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32),
                onPressed: _agregar,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: tareasDelUsuario(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final docs = [...snapshot.data!.docs];

              docs.sort((a, b) {
                final dataA = a.data() as Map<String, dynamic>;
                final dataB = b.data() as Map<String, dynamic>;
                final Timestamp? fa = dataA['fechaCreacion'];
                final Timestamp? fb = dataB['fechaCreacion'];
                final int ma = fa?.millisecondsSinceEpoch ??
                    DateTime.now().millisecondsSinceEpoch;
                final int mb = fb?.millisecondsSinceEpoch ??
                    DateTime.now().millisecondsSinceEpoch;
                return mb.compareTo(ma);
              });

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (ctx, i) {
                  final data = docs[i].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['titulo']),
                    leading: Switch(
                      value: data['completada'] ?? false,
                      onChanged: (val) => actualizarTarea(docs[i].id, val),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => eliminarTarea(docs[i].id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
