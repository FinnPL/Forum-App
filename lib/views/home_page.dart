import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';

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
    //fetch data from API
    getData();
  }

  getData() async {
    await remoteService.getToken('HerrSueer', '12123').whenComplete(() async => posts = await remoteService.getPostsPage(0));
    if (posts != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }
    addNextPage(){
      page++;
      remoteService.getPostsPage(page).then((value) => setState(() {
        posts!.addAll(value!);
        if(value.isEmpty) end = true;
      }));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AddPostWidget(),
          ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Palette.OrangeToDark,
      ),
      body:
      RefreshIndicator(
        onRefresh: () async {
          page = 0;
          end = false;
          await remoteService.getPostsPage(0).then((value) => setState(() {
            posts = value;
          }));
        },
    backgroundColor: Palette.BlueToDark[200], child:Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          itemBuilder: (context, index) {

            int? post_length = posts?.length;

              if(index == post_length&& !end) {
                addNextPage();
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            } else if(index < post_length!){
              final post = posts?[index];
              final postTitle = post?.title;
              final postContent = post?.content;
              final authorName = post?.userName;
              final postDate = post?.date.toString();
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Palette.BlueToLight[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    title: Text(
                      postTitle ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors
                            .black54),
                        const SizedBox(width: 4),
                        Text(
                          postDate.toString(),
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.account_circle, size: 16, color: Colors
                            .black54),
                        const SizedBox(width: 4),
                        Text(
                          authorName.toString(),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    trailing:
                    const Icon(
                        Icons.arrow_forward_ios, color: Palette.OrangeToDark),

                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            FullScreenPostWidget(
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
            }
          },
        ),
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

  FullScreenPostWidget({super.key,
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
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Palette.OrangeToDark,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  postTitle!,
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
                Text(authorName!, style: TextStyle(color: Palette.YellowToDark[100])),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, color: Palette.YellowToDark[100]),
                const SizedBox(width: 8),
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

class _AddPostWidgetState extends State<AddPostWidget>{
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
              padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
              child: Row(
                children: [
                  const Text(
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
                  child: Column(
                    children: [
                      TextField(
                        controller: title_controller,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: Palette.OrangeToDark,fontSize: 20),
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
                          labelStyle: TextStyle(color: Palette.OrangeToDark,fontSize: 20),
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
                            if(titel.isEmpty|content.isEmpty){
                              //show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill in all fields')));
                              return;
                            }
                            remoteService.addPost(
                                  title: titel,
                                  content: content,
                              );
                              //return to home page
                              Navigator.of(context).pop();
                            },
                          icon: Icon(Icons.send), label: Text('Post')
                      ),
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