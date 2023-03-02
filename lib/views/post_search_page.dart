import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/post_list_view.dart';

class PostPage extends StatefulWidget {
  final String search;

  const PostPage({
    Key? key,
    required this.search,
  }) : super(key: key);

  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  List<Post>? posts;
  var isLoaded = false;
  int page = 0;
  bool end = false;


  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    posts = await remoteService.search(widget.search,0);
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  addNextPage() {
    page++;
    remoteService.search(widget.search,page).then((value) => setState(() {
      posts!.addAll(value!);
      if (value.isEmpty) end = true;
    }));
  }

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
              child: Visibility(
              visible: isLoaded,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  int? postLength = posts?.length;

                  if (index == postLength && !end) {
                    addNextPage();
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (index < postLength!) {
                    final post = posts![index];
                    return PostWidget(post: post);
                  }
                  return null;
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