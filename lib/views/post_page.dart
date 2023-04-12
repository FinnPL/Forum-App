import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:forum/models/comment.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/local_services.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/comment_list_view.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/user_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FullScreenPostWidget extends StatefulWidget {
  final Post post;

  const FullScreenPostWidget({Key? key, required this.post}) : super(key: key);

  @override
  FullScreenPostWidgetState createState() => FullScreenPostWidgetState();
}

class FullScreenPostWidgetState extends State<FullScreenPostWidget> {
  late List<Comment> comments = [];
  late Post post;
  int page = 0;
  bool end = false;
  bool isLoaded = false;
  TextEditingController commentController = TextEditingController();
  bool isOwnPost = false;
  Image? image;
  Uint8List? imageBytes;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    post = widget.post;
    getData();
  }

  getData() async {
    RemoteService().getPostPicture(post.id).then((value) {
      setState(() {
        imageBytes = value;
        image = Image.memory(value);
      });
    });
    comments = await remoteService.getComments(0, post.id);
    setState(() {
      isLoaded = true;
    });
    LocalServices().getUserId().then((value) {
      if (value == post.userId) {
        setState(() {
          isOwnPost = true;
        });
      }
    });
  }

  addNextPage() {
    page++;
    remoteService.getComments(page, post.id).then((value) => setState(() {
          comments.addAll(value);
          if (value.isEmpty) end = true;
        }));
    //reload the page
  }

  //Page to display a post in full screen including the post Content and Comments
  @override
  Widget build(BuildContext context) {
    String date = LocalServices().getFormatedDate(post.date);

    return Scaffold(
      backgroundColor: Palette.BlueToDark,
      appBar: isOwnPost
          ? buildEditAppBar(context, post, image)
          : buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: Palette.BlueToDark,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Palette.BlueToLight[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(
                    top: 16, bottom: 16, left: 16, right: 16),
                padding: const EdgeInsets.only(
                    top: 16, bottom: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 15,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserPage(
                                  userId: post.userId,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            post.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (post.edited)
                          const Text(
                            '(Edited)',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.content,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    // Picture here if it exists
                    if (image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child:  GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImage(image: imageBytes!),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'imageHero',
                            child: image!,
                          ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Palette.BlueToLight,
                padding: const EdgeInsets.only(
                    top: 16, bottom: 16, left: 16, right: 16),
                child: Row(
                  children: const [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Palette.OrangeToDark,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 16, left: 16, right: 16),
                child: TextField(
                  cursorColor: Colors.black,
                  controller: commentController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          String text = commentController.text;
                          if (commentController.text.isNotEmpty) {
                            remoteService
                                .addComment(post.id, text)
                                .then((value) => {
                                      if (value == true)
                                        {
                                          setState(() {
                                            comments.insert(
                                                0,
                                                Comment(
                                                    userId: '0',
                                                    content: text,
                                                    date: DateTime.now(),
                                                    userName: 'Me',
                                                    id: '0'));
                                          })
                                        }
                                    });
                            commentController.clear();
                          }
                        },
                        icon: const Icon(Icons.send)),
                    fillColor: Palette.Back,
                    filled: true,
                    hintText: 'Write a comment',
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    int? postLength = comments.length;
                    if (index == postLength && !end) {
                      addNextPage();
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (index < postLength) {
                      final comment = comments[index];
                      return CommentWidget(comment: comment);
                    }
                    return null;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List  image;

  const FullScreenImage({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BlueToDark,
      appBar: buildAppBar(context),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: InteractiveViewer(
          maxScale: 10.0,
          minScale: 0.75,
          boundaryMargin: const EdgeInsets.all(30.0),
          scaleEnabled: true,
          constrained: true,
          child: Hero(
            tag: 'imageHero',
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.memory(image),
              ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final tempDir = await getTemporaryDirectory();
          String fileExtension = 'jpg';
          if (image[0] == 0x47) {
            fileExtension = 'gif';
          } else if (image[0] == 0x89) {
            fileExtension = 'png';
          }
          final file = File('${tempDir.path}/image.$fileExtension');
          await file.writeAsBytes(image);
          Share.shareXFiles([XFile(file.path)]);
        },
        tooltip: 'Share Image',
        child: const Icon(Icons.share),
      ),
    );
  }
}