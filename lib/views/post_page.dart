
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/models/comment.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/comment_list_view.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/post_page.dart';

class FullScreenPostWidget extends StatefulWidget {
  final Post post;

  const FullScreenPostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<FullScreenPostWidget> createState() => _FullScreenPostWidgetState(post);
}

class _FullScreenPostWidgetState extends State<FullScreenPostWidget> {
  late List<Comment> comments = [];
  final Post post;
  int page = 0;
  bool end = false;
  bool isLoaded = false;

  _FullScreenPostWidgetState(this.post);


  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    comments = await remoteService.getComments(0, post.id);
    if (comments != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  addNextPage() {
    page++;
    remoteService.getComments(page, post.id).then((value) =>
        setState(() {
          comments!.addAll(value!);
          if (value.isEmpty) end = true;
        }));
  }


  //Page to display a post in full screen including the post Content and Comments
  @override
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
              decoration: BoxDecoration(
                color: Palette.BlueToLight[400],
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 16, right: 16),
              padding: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 15,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.userName}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 15,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$date',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child:
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    child:
                    Text(
                      post.content,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Palette.BlueToLight,
              padding: const EdgeInsets.only(
                  top: 16, bottom: 16, left: 16, right: 16),
              child: Row(
                children: [
                  Text(
                    'Comments',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Palette.OrangeToDark,
                    ),
                  ),
                ],
              ),

            ),
            Expanded(child:
            ListView.builder(
                itemBuilder: (context, index) {
                  int? post_length = comments?.length;

                  if (index == post_length && !end) {
                    addNextPage();
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (index < post_length!) {
                    final comment = comments![index];
                    return CommentWidget(comment: comment);
                  }
                }
            )
            ),
          ],
        ),
      ),
    );
  }
}
