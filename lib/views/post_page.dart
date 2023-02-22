
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';

class FullScreenPostWidget extends StatelessWidget {
  final Post post;

  const FullScreenPostWidget({Key? key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BlueToDark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Palette.BlueToDark[200],
            padding: const EdgeInsets.only(top: 32),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Palette.OrangeToDark,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Palette.OrangeToDark,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Palette.BlueToDark[200],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.person, color: Palette.YellowToDark[100]),
                const SizedBox(width: 8),
                Text(post.userName,
                    style: TextStyle(color: Palette.YellowToDark[100])),
                const SizedBox(width: 16),
                Icon(Icons.access_time, color: Palette.YellowToDark[100]),
                const SizedBox(width: 8),
                Text(
                    '${post.date.day}.${post.date.month}.${post.date.year} - ${post.date.hour}:${post.date.minute}',
                    style: TextStyle(color: Palette.YellowToDark[100])),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  post.content,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}