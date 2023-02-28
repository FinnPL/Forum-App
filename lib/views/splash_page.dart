import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/login_page.dart';

class Splash_page extends StatefulWidget {
  const Splash_page({super.key});

  @override
  _Splash_pageState createState() => _Splash_pageState();
}

class _Splash_pageState extends State<Splash_page> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  Future<void> checkIfLoggedIn() async {
    setState(() {
      _isLoading = true;
    });

    RemoteService remoteService = RemoteService();
    bool isLoggedIn = await remoteService.isLoggedIn();

    setState(() {
      _isLoading = false;
    });

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  const SizedBox(height: 150),
                  Image.asset(
                    'assets/images/ghse-banner.png',
                    fit: BoxFit.contain,
                    height: 150,
                  ),
                  const SizedBox(height: 200),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
      ),
      backgroundColor: Palette.BlueToLight[500],
    );
  }
}
