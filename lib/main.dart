import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/home_page.dart';

void main() =>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkLogin();
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
      home:  const HomePage(),
    );
  }
}
