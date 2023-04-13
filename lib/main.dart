import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/local_services.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/login_page.dart';
import 'package:forum/views/post_page.dart';
import 'package:forum/views/search_page.dart';
import 'package:forum/views/user_page.dart';

import 'package:go_router/go_router.dart';

import 'models/post.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(
    redirect: (BuildContext context, GoRouterState state) async {
      final bool isAuthed = await LocalServices().isAuth();
      if (!isAuthed) {
        return '/login';
      }
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
                name: 'post',
                path: 'post/:id',
                builder: (context, state) =>
                    FullScreenPostWidget(id: state.params['id']!)),
            GoRoute(
                name: 'search',
                path: 'search',
                builder: (context, state) => const SearchPage()),
            GoRoute(
                name: 'user',
                path: 'user/:id',
                builder: (context, state) =>
                    UserPage(userId: state.params['id']!)),
          ]),
    ]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GHSE Forum',
      theme: ThemeData(
        primarySwatch: Palette.BlueToDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Palette.OrangeToDark,
          selectionColor: Palette.OrangeToDark,
          selectionHandleColor: Palette.OrangeToDark,
        ),
      ),
      routerConfig: _router,
    );
  }
}
