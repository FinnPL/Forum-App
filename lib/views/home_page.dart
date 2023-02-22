import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/login_page.dart';

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
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AccountPage())),
              icon: const Icon(Icons.person)),
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

class AddPostWidget extends StatefulWidget {
  const AddPostWidget({Key? key}) : super(key: key);

  @override
  _AddPostWidgetState createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget> {
  final title_controller = TextEditingController();
  final content_controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    title_controller.dispose();
    content_controller.dispose();
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
                    'Create a new post',
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
                      controller: title_controller,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                            color: Palette.OrangeToDark, fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: content_controller,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        labelStyle: TextStyle(
                            color: Palette.OrangeToDark, fontSize: 20),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Palette.OrangeToDark),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                        onPressed: () async {
                          var titel = title_controller.text;
                          var content = content_controller.text;
                          if (titel.isEmpty | content.isEmpty) {
                            //show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please fill in all fields')));
                            return;
                          }
                          remoteService.addPost(
                            title: titel,
                            content: content,
                          );
                          //return to home page
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.send),
                        label: Text('Post')),
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

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
                    'Account',
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
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                        onPressed: () async {
                          await remoteService.logout();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => LoginPage()),
                              (route) => false);
                        },
                        icon: Icon(Icons.logout),
                        label: Text('Logout')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
