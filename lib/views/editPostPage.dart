import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forum/models/post.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/post_page.dart';
import 'package:image_picker/image_picker.dart';

class EditPostPage extends StatefulWidget {
  const EditPostPage({Key? key, required this.post, required this.image})
      : super(key: key);
  final Post post;
  final Image? image;

  @override
  EditPostPageState createState() => EditPostPageState();
}

class EditPostPageState extends State<EditPostPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  File? image;
  late Image? prevImage;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.post.title;
    contentController.text = widget.post.content;
    prevImage = widget.image;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
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
                    'Update your post',
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
                      controller: titleController,
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
                      controller: contentController,
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
                    if (image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Image.file(image!),
                      )
                    else if (prevImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: prevImage,
                      ),
                    ElevatedButton.icon(
                      onPressed: () {
                        pickImage();
                      },
                      label: const Text('Upload Picture'),
                      icon: const Icon(Icons.image),
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          var title = titleController.text;
                          var content = contentController.text;
                          if (title.isEmpty | content.isEmpty) {
                            //show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please fill in all fields')));
                            return;
                          }
                          widget.post.title = title;
                          widget.post.content = content;
                          RemoteService()
                              .updatePost(widget.post.id, widget.post);
                          if (image != null) {
                            RemoteService().uploadImage(image!, widget.post.id);
                          }
                          //return to home page
                          Navigator.of(context).pop();
                          //reload post page with new post
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullScreenPostWidget(
                                        post: widget.post,
                                      )));
                        },
                        icon: const Icon(Icons.post_add),
                        label: const Text('Update Post')),
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
