import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/post_page.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post});

  Widget build(BuildContext context) {
    String date;
    if (post.date.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      date = '${post.date.hour}:';
      if (post.date.hour < 10) {
        date = '0$date';
      }
      if (post.date.minute < 10) {
        date = '${date}0${post.date.minute}';
      } else {
        date = '$date${post.date.minute}';
      }
    } else {
      date = '${post.date.day}/${post.date.month}/${post.date.year}';
    } //💀

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.BlueToLight[400],
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          title: Text(
            post.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.account_circle, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                post.userName,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.black54),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          trailing:
          const Icon(Icons.arrow_forward_ios, color: Palette.BlueToDark),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => FullScreenPostWidget(
                post: post,
              ),
            ));
          },
        ),
      ),
    );
  }
}