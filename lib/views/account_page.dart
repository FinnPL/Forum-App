import 'package:flutter/material.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/local_services.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/post_list_view.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);
  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool _isLoading = true;

  String username = '';
  String userId = '';
  String bio = '';
  late Image profilePicture = Image.asset('assets/images/def1.png');

  bool _isLoadingPosts = true;
  List<Post>? posts;
  int page = 0;
  bool end = false;

  @override
  void initState() {
    super.initState();
    LocalServices().getUserName().then((value) {
      username = value!;
      setState(() {
        _isLoading = false;
      });
    });
    LocalServices().getUserId().then((value) {
      userId = value!;

      RemoteService().getUserByUUID(userId).then((value) {
        setState(() {
          bio = value.bio;
        });
      });

      RemoteService().getProfilePicture(userId).then((value) {
        setState(() {
          profilePicture = Image.memory(value);
        });
      });
      RemoteService().getPostsOfUser(0,userId).then((value) {
        posts = value;
        setState(() {
          _isLoadingPosts = false;
        });
      });
    });
  }

  addNextPage() {
    page++;
    remoteService.getPostsOfUser(page,userId).then((value) => setState(() {
          posts!.addAll(value);
          if (value.isEmpty) end = true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildProfileAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Palette.BlueToDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profilePicture.image,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        bio,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Visibility(
                          visible: !_isLoadingPosts,
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
              ),
            ),
    );
  }
}
