import '../model/WeeklyTest_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyTestController {
  final String apiUrl =
      'https://ddemo.xscholar.com/sms/api/adminapp/WeeklyTest.php?'; // Replace with your API endpoint

  Future<List<WeeklyTest>> getWeeklyTest({required String token}) async {
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'operation': 'ShowWeeklyTest', 'status': 'Unpublished'}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];
        return data.map((item) {
          return WeeklyTest.fromJson(item);
        }).toList();
      } else {
        throw Exception('Data not found in response');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<List<WeeklyTest>> fetchPubStudentData({required String token}) async {
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'operation': 'ShowWeeklyTest', 'status': 'Published'}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];
        return data.map((item) {
          return WeeklyTest.fromJson(item);
        }).toList();
      } else {
        throw Exception('Data not found in response');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<List<WeeklyTest>> fetchSaveStudentData({required String token}) async {
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'operation': 'ShowWeeklyTest', 'status': 'Save'}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];
        return data.map((item) {
          return WeeklyTest.fromJson(item);
        }).toList();
      } else {
        throw Exception('Data not found in response');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}