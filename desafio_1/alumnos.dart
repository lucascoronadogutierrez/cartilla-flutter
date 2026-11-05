class Alumno {
  final String nombre;
  final String apellido;
  final int edad;
  final List<double> notas;

  Alumno({
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.notas,
  });

  double calcularPromedio() {
    double suma = 0;
    for (double nota in notas) {
      suma += nota;
    }
    return suma / notas.length;
  }

  String estadoFinal() {
    double promedio = calcularPromedio();
    if (promedio >= 6) {
      return 'Aprobado';
    } else if (promedio >= 4) {
      return 'Recuperatorio';
    } else {
      return 'Desaprobado';
    }
  }

  @override
  String toString() {
    return '$nombre $apellido — ${estadoFinal()}';
  }
}

void main() {
  List<Alumno> alumnos = [
    Alumno(nombre: 'Sofía', apellido: 'Pérez', edad: 17, notas: [8, 9, 7]),
    Alumno(nombre: 'Lucas', apellido: 'Gómez', edad: 16, notas: [4, 5, 3]),
    Alumno(nombre: 'Ana', apellido: 'Díaz', edad: 18, notas: [6, 7, 6.5]),
    Alumno(nombre: 'Mateo', apellido: 'Ruiz', edad: 17, notas: [2, 3, 4]),
    Alumno(nombre: 'Valentina', apellido: 'Torres', edad: 16, notas: [10, 9, 10]),
  ];

  for (Alumno alumno in alumnos) {
    print(alumno);
  }

  Alumno mejor = alumnos[0];
  for (Alumno alumno in alumnos) {
    if (alumno.calcularPromedio() > mejor.calcularPromedio()) {
      mejor = alumno;
    }
  }
  print('Promedio más alto: ${mejor.nombre} ${mejor.apellido} con ${mejor.calcularPromedio().toStringAsFixed(2)}');

  int aprobaron = 0;
  int desaprobaron = 0;
  for (Alumno alumno in alumnos) {
    if (alumno.estadoFinal() == 'Aprobado') {
      aprobaron++;
    } else {
      desaprobaron++;
    }
  }
  print('Aprobaron: $aprobaron');
  print('No aprobaron: $desaprobaron');

  alumnos.sort((a, b) => b.calcularPromedio().compareTo(a.calcularPromedio()));
  print('Ordenados por promedio:');
  for (Alumno alumno in alumnos) {
    print('${alumno.nombre} ${alumno.apellido}: ${alumno.calcularPromedio().toStringAsFixed(2)}');
  }
}
