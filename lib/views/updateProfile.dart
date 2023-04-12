

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/home_page.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileWidget extends StatefulWidget {
  final Image profilePicture;
  final String bio;
  const UpdateProfileWidget({Key? key, required this.profilePicture, required this.bio}) : super(key: key);
  @override
  UpdateProfileWidgetState createState() => UpdateProfileWidgetState();
}

class UpdateProfileWidgetState extends State<UpdateProfileWidget>{
  final controller = TextEditingController();
  File? image;
  Image? profilePicture;
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
  void initState() {
    super.initState();
    controller.text = widget.bio;
    profilePicture = widget.profilePicture;
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
        padding: const EdgeInsets.all(20),
        color: Palette.BlueToLight[50],
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Update Profile',
              style: TextStyle(
                color: Palette.OrangeToDark,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if(image != null)
              CircleAvatar(
                radius: 90,
                backgroundImage: FileImage(image!),
              )
              else
              Hero(tag: profilePicture!, child:
                  CircleAvatar(
                  radius: 90,
                  backgroundImage: profilePicture?.image,
            ))
            ,
            ElevatedButton.icon(
              onPressed: () {
                pickImage();
              },
              label: const Text('Upload Profile Picture'),
              icon: const Icon(Icons.image),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(color: Colors.white),
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
            const SizedBox(height:10),
            ElevatedButton.icon(
              label: const Text('Confirm'),
              icon: const Icon(Icons.save),
              onPressed: ()  {
                  if (image != null) remoteService.uploadProfileImage(image!);
                  remoteService.updateBio(controller.text).then((value) {
                    localServices.getUserId().then((value)
                    {
                      Navigator.pop(context);
                    }
                    );
                  }
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

}