import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/palette.dart';

class Post extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _PostState();
}

class _PostState extends State<Post>{
  final String postTitle = 'Post Title';
  final String postContent= 'Post Content';
  final String authorName= 'Author Name';
  final String postDate= 'Post Date';



  @override
  Widget build(BuildContext context) {
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
            postTitle,
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
                postDate,
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(width: 16),
              Icon(Icons.account_circle, size: 16, color: Colors.black54),
              SizedBox(width: 4),
              Text(
                authorName,
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
                authorName: authorName,
                postDate: postDate,
              ),
            ));
          },
        ),
      ),
    );
  }
}

class FullScreenPostWidget extends StatelessWidget {
  final String postTitle;
  final String postContent;
  final String authorName;
  final String postDate;

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
                  postTitle,
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
                Text(authorName, style: TextStyle(color: Palette.YellowToDark[100])),
                SizedBox(width: 16),
                Icon(Icons.calendar_today, color: Palette.YellowToDark[100]),
                SizedBox(width: 8),
                Text(postDate, style: TextStyle(color: Palette.YellowToDark[100])),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  postContent,
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