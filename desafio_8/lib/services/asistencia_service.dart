import 'package:cloud_firestore/cloud_firestore.dart';
import 'fechas.dart';
import 'notification_service.dart';

final db = FirebaseFirestore.instance;

Future<String> registrarAsistencia(String nombre) async {
  final hoy = fechaHoy();

  final existentes = await db
      .collection('asistencias')
      .where('nombre', isEqualTo: nombre)
      .where('fecha', isEqualTo: hoy)
      .get();

  if (existentes.docs.isNotEmpty) {
    await NotificationService.mostrar(
      titulo: 'Asistencia repetida',
      cuerpo: '$nombre ya está registrado hoy',
    );
    return '$nombre ya estaba registrado hoy';
  }

  await db.collection('asistencias').add({
    'nombre': nombre,
    'fecha': hoy,
    'hora': horaActual(),
  });
  return 'Asistencia registrada: $nombre';
}

Stream<QuerySnapshot> asistenciasDelDia() {
  return db
      .collection('asistencias')
      .where('fecha', isEqualTo: fechaHoy())
      .snapshots();
}

Future<void> limpiarRegistroDelDia() async {
  final docs = await db
      .collection('asistencias')
      .where('fecha', isEqualTo: fechaHoy())
      .get();

  final batch = db.batch();
  for (final doc in docs.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit();
}
