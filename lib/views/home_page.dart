import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/account_page.dart';
import 'package:forum/views/create_post.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/post_list_view.dart';
import 'package:forum/views/search_page.dart';


RemoteService remoteService = new RemoteService();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    print('build called');
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
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const Icon(Icons.search),color: Palette.BlueToLight[400]),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AccountPage())),
              icon: const Icon(Icons.person),color: Palette.BlueToLight[400],),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AddPostWidget(),
          ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Palette.OrangeToDark,
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
              int? post_length = posts?.length;

              if (index == post_length && !end) {
                addNextPage();
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (index < post_length!) {
                final post = posts![index];
                return PostWidget(post: post);
              }
            },
          ),
        ),
      ),
      backgroundColor: Palette.BlueToDark,
    );
  }
}











