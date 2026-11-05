import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';

class DetalleScreen extends StatelessWidget {
  final Post post;

  const DetalleScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post ${post.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(post.cuerpo, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
