import '../model/StudentAttd_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAttdController {
  final String apiUrl =
      'https://ddemo.xscholar.com/sms/api/adminapp/StudentAttendance.php?'; // Replace with your API endpoint

  Future<List<StudentAttd>> getAbsentStdData({required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode({'operation': 'StudentAttendance'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) {
              return StudentAttd.fromJson(item);
          }).toList();
        } else {
          throw Exception('Data not found in response');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      rethrow; // Rethrow the error to handle it at the caller level
    }
  }

  Future<List<StudentAttd>> getPresentStdData({required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode({'operation': 'StudentAttendance', 'status':"Present"}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) {
            return StudentAttd.fromJson(item);
          }).toList();
        } else {
          throw Exception('Data not found in response');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      rethrow; // Rethrow the error to handle it at the caller level
    }
  }
}
