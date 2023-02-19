import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post>? posts;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData() async {
    posts = await RemoteService().getPosts();
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
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
            Text(
              '  GHSE Forum',
              style: TextStyle(color: Palette.OrangeToLight),
            ),
          ],
        ),
      ),
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
          itemCount: posts?.length,
          itemBuilder: (context, index) {
            final post = posts?[index];
            final postTitle = post?.title;
            final postContent = post?.body;
            final authorName = post?.userId;
            final postDate = post?.id;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.BlueToLight[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  title: Text(
                    postTitle ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        postDate.toString(),
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.account_circle, size: 16, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        authorName.toString(),
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  trailing:
                  Icon(Icons.arrow_forward_ios, color: Palette.OrangeToDark),

                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FullScreenPostWidget(
                        postTitle: postTitle,
                        postContent: postContent,
                        authorName: authorName.toString(),
                        postDate: postDate.toString(),
                      ),
                    ));
                  },
                ),
              ),
            );

          },
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}


class FullScreenPostWidget extends StatelessWidget {
   String? postTitle;
   String? postContent;
   String? authorName;
   String? postDate;

  FullScreenPostWidget({
    required this.postTitle,
    required this.postContent,
    required this.authorName,
    required this.postDate,
  });



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
                  icon: Icon(Icons.arrow_back_ios_new),
                  color: Palette.OrangeToDark,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  postTitle!,
                  style: TextStyle(
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
                SizedBox(width: 8),
                Text(authorName!, style: TextStyle(color: Palette.YellowToDark[100])),
                SizedBox(width: 16),
                Icon(Icons.calendar_today, color: Palette.YellowToDark[100]),
                SizedBox(width: 8),
                Text(postDate!, style: TextStyle(color: Palette.YellowToDark[100])),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  postContent!,
                  style: TextStyle(
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