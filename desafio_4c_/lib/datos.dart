class Post {
  final int id;
  final String titulo;
  final String cuerpo;

  const Post({required this.id, required this.titulo, required this.cuerpo});
}

const List<Post> posts = [
  Post(id: 1, titulo: 'Aprendiendo Flutter', cuerpo: 'Flutter es el framework de Google para hacer apps móviles.'),
  Post(id: 2, titulo: 'Dart desde cero', cuerpo: 'Dart es el lenguaje que usa Flutter.'),
  Post(id: 3, titulo: 'Git y GitHub', cuerpo: 'Git guarda el historial de versiones de tu código.'),
  Post(id: 4, titulo: 'Riverpod para el estado', cuerpo: 'Riverpod permite compartir el estado entre pantallas.'),
  Post(id: 5, titulo: 'Publicar en la Play Store', cuerpo: 'Para publicar necesitás un AAB firmado con tu keystore.'),
];
