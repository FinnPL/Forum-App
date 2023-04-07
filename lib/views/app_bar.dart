import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/editPostPage.dart';
import 'package:forum/views/search_page.dart';
import 'package:forum/views/user_page.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      color: Palette.OrangeToLight,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    titleSpacing: 0,
    title: Row(
      children: <Widget>[
        Image.asset(
          'assets/images/ghse_logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        const Text(
          ' Forum',
          style: TextStyle(color: Palette.OrangeToLight),
        ),
      ],
    ),
  );
}

AppBar buildMainAppBar(BuildContext context) {
  return AppBar(
    title: Row(
      children: <Widget>[
        Image.asset(
          'assets/images/ghse_logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        const Text(
          ' Forum',
          style: TextStyle(color: Palette.OrangeToLight),
        ),
      ],
    ),
    actions: [
      IconButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const SearchPage())),
          icon: const Icon(Icons.search),
          color: Palette.BlueToLight[400]),
      IconButton(
        onPressed: () {
          localServices.getUserId().then((value)
          {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) =>  UserPage(userId: value!))
            );
          }
          );
        },
        icon: const Icon(Icons.person),
        color: Palette.BlueToLight[400],
      ),
    ],
  );
}


AppBar buildEditAppBar(BuildContext context, Post post, Image? image) {
  return AppBar(
    leading: IconButton(
      color: Palette.OrangeToLight,
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    titleSpacing: 0,
    title: Row(
      children: <Widget>[
        Image.asset(
          'assets/images/ghse_logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        const Text(
          ' Forum',
          style: TextStyle(color: Palette.OrangeToLight),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.edit),
        color: Palette.BlueToLight[400],
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => EditPostPage(post: post, image: image)),
          );

        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        color: Palette.BlueToLight[400],
        onPressed: () {
          //Show popup
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Delete Post"),
                content: const Text("Are you sure you want to delete this post?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      RemoteService().deletePost(post.id);
                    },
                  ),
                ],
              );
            },
          );
        }
      )
    ],
  );
}
