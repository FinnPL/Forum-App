import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/post_page.dart';

class PostPage extends StatefulWidget {
  final List<Post>? posts;
  final String search;

  const PostPage({
    Key? key,
    required this.posts,
    required this.search,
  }) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
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
                children: [
                  Text(
                    'Search Results for: ${widget.search}',
                    style: const TextStyle(
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
                child: ListView.builder(
                  itemCount: widget.posts!.length,
                  itemBuilder: (context, index) {
                    return PostWidget(post: widget.posts![index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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