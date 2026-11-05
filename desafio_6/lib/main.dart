import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'presentation/screens/tareas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  await Hive.initFlutter();
  await Hive.openBox('preferencias');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('preferencias').listenable(),
      builder: (context, box, _) {
        final bool oscuro = box.get('modoOscuro', defaultValue: false);

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
          themeMode: oscuro ? ThemeMode.dark : ThemeMode.light,
          home: const TareasScreen(),
        );
      },
    );
  }
}
