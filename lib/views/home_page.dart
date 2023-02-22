import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/account_page.dart';
import 'package:forum/views/create_post.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/login_page.dart';
import 'package:forum/views/post_list_view.dart';
import 'package:forum/views/post_page.dart';

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
        onRefresh: () async {
          page = 0;
          end = false;
          await remoteService.getPostsPage(0).then((value) => setState(() {
                posts = value;
              }));
        },
        backgroundColor: Palette.BlueToDark[200],
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




class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final search_controller = TextEditingController();
  List<Post>? posts;

  @override
  void dispose() {
    search_controller.dispose();
    super.dispose();
  }

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
                children: const [
                  Text(
                    'Search for Posts',
                    style: TextStyle(
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
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextField(
                      controller: search_controller,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(
                            color: Palette.OrangeToDark, fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                        onPressed: () async {
                          var page = 0;
                          var search = search_controller.text;
                          if (search.isEmpty) {
                            //show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please fill in all fields')));
                            return;
                          }
                          posts = await remoteService.search(search, page);
                          //show post page
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PostPage(posts: posts, search: search)));
                        },
                        icon: Icon(Icons.search),
                        label: Text('Search')),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






