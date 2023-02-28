import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

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
      String user_name, String user_id, String token, String expiration) async {
    await storage.write(key: 'user_name', value: user_name);
    await storage.write(key: 'user_id', value: user_id);
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'expiration', value: expiration);
  }
  deleteUserData() async {
    await storage.deleteAll();
  }
}