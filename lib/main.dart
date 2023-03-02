import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/splash_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const SplashPage(),
    );
  }
}
