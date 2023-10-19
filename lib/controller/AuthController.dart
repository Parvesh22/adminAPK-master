import '../model/AuthModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController{
  final String apiUrl = 'https://ddemo.xscholar.com/sms/api/adminapp/login.php'; // Replace with your API endpoint

  Future<dynamic> signIn({required String name, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'UserName': name, 'Password': password, 'operation': 'Login'}),
      );

      if (response.statusCode == 200) {
        // User signed in successfully
            final Map<String, dynamic> responsedata = json.decode(response.body);
            //print(responsedata);
             var token = responsedata['token'];
            var Phone = responsedata['Phone'];
            var Email = responsedata['Email'];
            var Image = responsedata['Image'];
            var UserName = responsedata['username'];
            var Institution = responsedata['Institution'];
            var School = responsedata['School'];
            var ProfileImg = responsedata['ProfileImg'];
             SharedPreferences prefs = await SharedPreferences.getInstance();
             await prefs.setString('token', token);
             await prefs.setString('Institution', Institution);
             await prefs.setString('PhoneNo', Phone);
             await prefs.setString('Email', Email);
             await prefs.setString('Image', Image);
             await prefs.setString('UserName', UserName);
             await prefs.setString('School', School);
            await prefs.setString('ProfileImg', ProfileImg);
             return true;
      } else {
        // Handle sign-in errors
        return false;
      }
    } catch (e) {
      // Handle network or other errors
        return false;
    }
  }
}