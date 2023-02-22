import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user_controller = TextEditingController();
  final password_controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    user_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/ghse_logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            const Text(
              '  GHSE Forum',
              style: TextStyle(color: Palette.OrangeToLight),
            ),
          ],
        ),
      ),
      body: Container(
        color: Palette.BlueToDark,
        child: Column(
          children: [
            Container(
              color: Palette.BlueToLight,
              padding: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 16, right: 16),
              child: Row(
                children: const [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Palette.OrangeToDark,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: user_controller,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                            color: Palette.OrangeToDark, fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: password_controller,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color: Palette.OrangeToDark, fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                        onPressed: () async {
                          if (user_controller.text.isEmpty ||
                              password_controller.text.isEmpty) {
                            return;
                          } else {
                            await remoteService
                                .getToken(user_controller.text,
                                    password_controller.text)
                                .then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage())));
                          }
                        },
                        icon: Icon(Icons.login),
                        label: Text('Login')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
