import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LocalServices {
  Future<String?> getUserName() async {
    return await storage.readAll().then((value) => value['user_name']);
  }

  Future<String?> getUserId() async {
    return await storage.readAll().then((value) => value['user_id']);
  }

  Future<String?> getToken() async {
    return await storage.readAll().then((value) => value['token']);
  }

  Future<String?> getExpiration() async {
    return await storage.readAll().then((value) => value['expiration']);
  }

  Future<bool> isAuth() async {
    if ((await getToken() != null) &&
        (DateTime.parse((await getExpiration())!).isAfter(DateTime.now()))) {
      return true;
    }
    return false;
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

  String getFormattedDate(DateTime date) {
    String formattedDate = '';
    if (date.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      formattedDate = '${date.hour}:';
      if (date.hour < 10) {
        formattedDate = '0$formattedDate';
      }
      if (date.minute < 10) {
        formattedDate = '${formattedDate}0${date.minute}';
      } else {
        formattedDate = '$formattedDate${date.minute}';
      }
    } else {
      formattedDate = '${date.day}/${date.month}/${date.year}';
    }
    return formattedDate;
  }
}
