import '../model/StaffAttd_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAttdController {
  final String apiUrl =
      'https://ddemo.xscholar.com/sms/api/adminapp/StaffAttendance.php?'; // Replace with your API endpoint

  Future<List<StaffAttd>> getAbsentStdData({required String token}) async {
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode({'operation': 'StaffAttendance'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) {
            return StaffAttd.fromJson(item);
          }).toList();
        } else {
          throw Exception('Data not found in response');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
  }

  Future<List<StaffAttd>> getPresentStdData({required String token}) async {
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode({'operation': 'StaffAttendance', 'status':"Present"}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) {
            return StaffAttd.fromJson(item);
          }).toList();
        } else {
          throw Exception('Data not found in response');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
  }
}
