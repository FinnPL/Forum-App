import 'package:flutter/material.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/login_page.dart';

class Splash_page extends StatefulWidget {
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
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Log In'),
              ),
      ),
    );
  }
}
