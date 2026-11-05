import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tarea {
  final String titulo;
  final String prioridad;
  final bool completada;

  const Tarea({
    required this.titulo,
    this.prioridad = 'media',
    this.completada = false,
  });

  Tarea copyWith({bool? completada}) {
    return Tarea(
      titulo: titulo,
      prioridad: prioridad,
      completada: completada ?? this.completada,
    );
  }
}

class TasksState {
  final List<Tarea> tareas;

  const TasksState({this.tareas = const []});

  int get completadas => tareas.where((t) => t.completada).length;
  int get pendientes => tareas.length - completadas;
}

class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  void agregar(String titulo, String prioridad) {
    state = TasksState(
      tareas: [...state.tareas, Tarea(titulo: titulo, prioridad: prioridad)],
    );
  }

  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);
    state = TasksState(tareas: nuevas);
  }

  void toggleCompletada(int indice) {
    final nuevas = [...state.tareas];
    nuevas[indice] = nuevas[indice].copyWith(
      completada: !nuevas[indice].completada,
    );
    state = TasksState(tareas: nuevas);
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksState>(
  (ref) => TasksNotifier(),
);
