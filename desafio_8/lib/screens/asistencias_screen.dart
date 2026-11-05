import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/asistencia_service.dart';
import '../services/fechas.dart';

class AsistenciasScreen extends StatelessWidget {
  const AsistenciasScreen({super.key});

  Future<void> _confirmarLimpieza(BuildContext context) async {
    final bool? confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpiar registro'),
        content: const Text('Se van a borrar todas las asistencias de hoy.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await limpiarRegistroDelDia();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asistencias de ${fechaHoy()}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: asistenciasDelDia(),
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
                  return dataB['hora'].compareTo(dataA['hora']);
                });

                if (docs.isEmpty) {
                  return const Center(child: Text('Todavía no hay asistencias hoy'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(data['nombre']),
                      subtitle: Text('${data['fecha']} - ${data['hora']}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmarLimpieza(context),
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Limpiar registro del día'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
