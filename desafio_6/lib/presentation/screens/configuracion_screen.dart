import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('preferencias');

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          final bool oscuro = box.get('modoOscuro', defaultValue: false);
          final bool notificaciones =
              box.get('notificaciones', defaultValue: true);

          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Modo oscuro'),
                subtitle: const Text('Cambia el tema de la app'),
                value: oscuro,
                onChanged: (bool valor) => box.put('modoOscuro', valor),
              ),
              SwitchListTile(
                title: const Text('Notificaciones'),
                subtitle: const Text('Recibir avisos de la app'),
                value: notificaciones,
                onChanged: (bool valor) => box.put('notificaciones', valor),
              ),
            ],
          );
        },
      ),
    );
  }
}
