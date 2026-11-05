import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'datos.dart';
import 'sesion.dart';

class AppShell extends StatelessWidget {
  final String ruta;
  final Widget child;

  const AppShell({super.key, required this.ruta, required this.child});

  @override
  Widget build(BuildContext context) {
    int seccion = 0;
    if (ruta.startsWith('/posts')) seccion = 1;
    if (ruta.startsWith('/profile')) seccion = 2;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: seccion,
        onDestinationSelected: (int i) {
          if (i == 0) context.go('/');
          if (i == 1) context.go('/posts');
          if (i == 2) context.go('/profile');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Posts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/posts'),
          child: const Text('Ver posts'),
        ),
      ),
    );
  }
}

class PostsScreen extends StatelessWidget {
  final String busqueda;

  const PostsScreen({super.key, required this.busqueda});

  @override
  Widget build(BuildContext context) {
    final lista = posts
        .where((p) => p.titulo.toLowerCase().contains(busqueda.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar y apretar enter',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (String texto) {
                context.go('/posts?search=$texto');
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final post = lista[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(post.titulo),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/posts/${post.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final int postId;

  const DetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final post = posts.firstWhere((p) => p.id == postId);

    return Scaffold(
      appBar: AppBar(title: Text(post.titulo)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Post ID: ${post.id}'),
            const SizedBox(height: 12),
            Text(post.cuerpo, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            sesion.value = false;
          },
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            sesion.value = true;
          },
          child: const Text('Iniciar sesión'),
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String ruta;

  const ErrorScreen({super.key, required this.ruta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Página no encontrada: $ruta')),
    );
  }
}
