import 'package:go_router/go_router.dart';
import 'screens.dart';
import 'sesion.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: sesion,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(ruta: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/posts',
          builder: (context, state) {
            final String busqueda = state.uri.queryParameters['search'] ?? '';
            return PostsScreen(busqueda: busqueda);
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final int id = int.parse(state.pathParameters['id']!);
                return DetailScreen(postId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
  redirect: (context, state) {
    final bool estaLogueado = sesion.value;
    final bool enLogin = state.uri.path == '/login';

    if (!estaLogueado && !enLogin) {
      return '/login';
    }
    if (estaLogueado && enLogin) {
      return '/';
    }
    return null;
  },
  errorBuilder: (context, state) => ErrorScreen(ruta: state.uri.toString()),
);
