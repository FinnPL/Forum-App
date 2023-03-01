import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/post_list_view.dart';

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
      appBar: buildAppBar(context),
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