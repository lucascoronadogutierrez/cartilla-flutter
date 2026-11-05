import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;

Future<void> agregarTarea(String titulo) async {
  try {
    await db.collection('tareas').add({
      'titulo': titulo,
      'completada': false,
      'prioridad': 'normal',
      'fechaCreacion': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  } catch (e) {
    print('Error al crear tarea: $e');
  }
}

Stream<QuerySnapshot> tareasDelUsuario() {
  return db
      .collection('tareas')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

Future<void> actualizarTarea(String docId, bool completada) async {
  await db.collection('tareas').doc(docId).update({
    'completada': completada,
    'fechaCompletado': completada ? FieldValue.serverTimestamp() : null,
  });
}

Future<void> eliminarTarea(String docId) async {
  await db.collection('tareas').doc(docId).delete();
}
