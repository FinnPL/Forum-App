import 'package:flutter/material.dart';

import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/create_post.dart';
import 'package:forum/views/post_list_view.dart';


RemoteService remoteService = RemoteService();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
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
    posts = await remoteService.getPostsPage(0);
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  addNextPage() {
    page++;
    remoteService.getPostsPage(page).then((value) => setState(() {
          posts!.addAll(value!);
          if (value.isEmpty) end = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AddPostWidget(),
          ));
        },
        backgroundColor: Palette.OrangeToDark,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        color: Palette.OrangeToDark,
        backgroundColor: Palette.BlueToLight[50],
        onRefresh: () async {
          page = 0;
          end = false;
          await remoteService.getPostsPage(0).then((value) => setState(() {
                posts = value;
              }));
        },
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
      backgroundColor: Palette.BlueToDark,
    );
  }
}











