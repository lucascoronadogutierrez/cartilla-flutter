String dosDigitos(int n) => n.toString().padLeft(2, '0');

String fechaHoy() {
  final d = DateTime.now();
  return '${d.year}-${dosDigitos(d.month)}-${dosDigitos(d.day)}';
}

String horaActual() {
  final d = DateTime.now();
  return '${dosDigitos(d.hour)}:${dosDigitos(d.minute)}:${dosDigitos(d.second)}';
}
