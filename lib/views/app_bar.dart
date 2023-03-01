import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/local_services.dart';
import 'package:forum/views/account_page.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/login_page.dart';
import 'package:forum/views/search_page.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      color: Palette.OrangeToLight,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    titleSpacing: 0,
    title: Row(
      children: <Widget>[
        Image.asset(
          'assets/images/ghse_logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        const Text(
          ' Forum',
          style: TextStyle(color: Palette.OrangeToLight),
        ),
      ],
    ),
  );
}

AppBar buildMainAppBar(BuildContext context) {
  return AppBar(
    title: Row(
      children: <Widget>[
        Image.asset(
          'assets/images/ghse_logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        const Text(
          ' Forum',
          style: TextStyle(color: Palette.OrangeToLight),
        ),
      ],
    ),
    actions: [
      IconButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const SearchPage())),
          icon: const Icon(Icons.search),
          color: Palette.BlueToLight[400]),
      IconButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AccountPage())),
        icon: const Icon(Icons.person),
        color: Palette.BlueToLight[400],
      ),
    ],
  );
}

AppBar buildProfileAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      color: Palette.OrangeToLight,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    titleSpacing: 0,
    title: Row(
      children: <Widget>[
        Image.asset(
          'assets/images/ghse_logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        const Text(
          ' Forum',
          style: TextStyle(color: Palette.OrangeToLight),
        ),
      ],
    ),
    actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          color: Palette.BlueToLight[400],
          onPressed: () {
            LocalServices().deleteUserData();
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          color: Palette.BlueToLight[400],
          onPressed: () {
            //TODO: Implement edit profile
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
    ],
  );
}
