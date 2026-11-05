import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _busquedaCtrl = TextEditingController();
  late Future<List<Post>> _postsFuture;
  bool _buscando = false;
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _postsFuture = _apiService.getPosts();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buscando
            ? TextField(
                controller: _busquedaCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar por título',
                  border: InputBorder.none,
                ),
                onChanged: (String texto) {
                  setState(() => _filtro = texto.toLowerCase());
                },
              )
            : const Text('Posts'),
        actions: [
          IconButton(
            icon: Icon(_buscando ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _buscando = !_buscando;
                if (!_buscando) {
                  _filtro = '';
                  _busquedaCtrl.clear();
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando posts...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text('Error al cargar los datos'),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _postsFuture = _apiService.getPosts();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final List<Post> posts = snapshot.data!
              .where((p) => p.titulo.toLowerCase().contains(_filtro))
              .toList();

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(post.titulo),
                subtitle: Text(
                  post.cuerpo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleScreen(post: post),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
