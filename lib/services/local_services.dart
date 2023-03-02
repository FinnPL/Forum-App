import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LocalServices {
  Future<String?> getUserName() async{
    return await storage.readAll().then((value) => value['user_name']);
  }

  Future<String?> getUserId() async{
    return await storage.readAll().then((value) => value['user_id']);
  }

  Future<String?> getToken() async{
    return await storage.readAll().then((value) => value['token']);
  }

  Future<String?> getExpiration() async{
    return await storage.readAll().then((value) => value['expiration']);
  }

  Future<void> writeUserData(
      String userName, String userId, String token, String expiration) async {
    await storage.write(key: 'user_name', value: userName);
    await storage.write(key: 'user_id', value: userId);
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'expiration', value: expiration);
  }
  deleteUserData() async {
    await storage.deleteAll();
  }
  String getFormatedDate(DateTime date) {
    String formatedDate = '';
    if (date.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      formatedDate = '${date.hour}:';
      if (date.hour < 10) {
        formatedDate = '0$formatedDate';
      }
      if (date.minute < 10) {
        formatedDate = '${formatedDate}0${date.minute}';
      } else {
        formatedDate = '$formatedDate${date.minute}';
      }
    } else {
      formatedDate = '${date.day}/${date.month}/${date.year}';
    }
    return formatedDate;
  }
}