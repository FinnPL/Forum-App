

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/user_page.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileWidget extends StatefulWidget {
  @override
  UpdateProfileWidgetState createState() => UpdateProfileWidgetState();
}

class UpdateProfileWidgetState extends State<UpdateProfileWidget>{
  final controller = TextEditingController();
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Update Profile'),
            const SizedBox(height: 20),
            if(image != null)
              CircleAvatar(
                radius: 70,
                backgroundImage: FileImage(image!),
              ),
            ElevatedButton(
              onPressed: () {
                pickImage();
              },
              child: const Text('Upload Image'),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(
                    color: Palette.OrangeToDark, fontSize: 20),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Palette.OrangeToDark),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Palette.OrangeToDark),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: ()  {
                  remoteService.uploadImage(image!);
                  remoteService.updateBio(controller.text).then((value) {
                    localServices.getUserId().then((value)
                    {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>  UserPage(userId: value!))
                      );
                    }
                    );
                  }
                  );
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

}