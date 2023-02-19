import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/views/post_view.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final _Post = <Post>[];

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

      //List of posts
      body: _buildBody(),
      backgroundColor: Palette.BlueToDark[300],
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),

      itemBuilder: (context, index) {
        if(index == _Post.length){
          _Post.addAll(_generatePost());
        }
        return _Post[index];
      },
    );
  }

  Iterable<Post> _generatePost() {
    return List.generate(20, (i) {
      return Post();
    });
  }

}