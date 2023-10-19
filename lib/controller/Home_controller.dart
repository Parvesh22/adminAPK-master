import '../model/Home_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  final String apiUrl =
      'https://ddemo.xscholar.com/sms/api/adminapp/dashboard.php?'; // Replace with your API endpoint

  Future geHomeData({required String token}) async {
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'operation': 'Dashboard'}),
    );
    return response.body;
  }
}
