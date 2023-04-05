import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forum/palette.dart';
import 'package:forum/services/remote_services.dart';
import 'package:forum/views/app_bar.dart';
import 'package:forum/views/home_page.dart';
import 'package:forum/views/user_page.dart';

class UpdateProfileWidget extends StatefulWidget {
  @override
  UpdateProfileWidgetState createState() => UpdateProfileWidgetState();
}

class UpdateProfileWidgetState extends State<UpdateProfileWidget>{
  final controller = TextEditingController();
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