import 'dart:convert';

import 'package:forum/models/auth.dart';
import 'package:forum/models/post.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  final api_url = 'http://192.168.178.54:8080/api/v1/';

  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  Future<List<Post>?> getPostsPage(String Token,int page) async {
    var url = Uri.parse('${api_url}post/page/$page');
    headers.addAll({'Authorization': 'Bearer $Token'});

    var response = await http.get(url,headers: headers);
    if (response.statusCode == 200) {
      var json = response.body;
      return postFromJson(json);
    }
  }

  Future<String?> register(String user_name, String password) async {
    var url = Uri.parse('${api_url}auth/register');
    final body = jsonEncode(Auth(userName: user_name, password: password).toJson());

    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      print('Registration successful');
      print('Token: ${response.body.substring(10,response.body.length-2)}');
      return response.body.substring(10,response.body.length-2);
    } else {
      print('Registration failed: ${response.statusCode}');
    }
  }

    Future<String?> getToken(String user_name, String password) async {
      var url = Uri.parse('${api_url}auth/authenticate');
      final body = jsonEncode(Auth(userName: user_name, password: password).toJson());

      final response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        print('LogIn successful');
        print('Token: ${response.body.substring(10,response.body.length-2)}');
        return response.body.substring(10,response.body.length-2);
      } else {
        print('LogIn failed: ${response.statusCode}');
      }
    }

}
