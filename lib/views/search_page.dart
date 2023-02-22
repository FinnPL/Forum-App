import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/post_list_view.dart';
import 'package:forum/views/post_search_page.dart';

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
        leading: IconButton(
          color: Palette.OrangeToLight,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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