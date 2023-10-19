import '../model/HomeWork_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeworkController {
  final String apiUrl =
      'https://ddemo.xscholar.com/sms/api/adminapp/ShowHomework.php?'; // Replace with your API endpoint

  Future<List<HomeworkModel>> getWeeklyTest({required String token}) async {
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {'Content-Type': 'application/json', 'Authorization': token},
        body: jsonEncode({'operation': 'ShowHomework'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final List<dynamic> data = responseData['data'];
          return data.map((item) {
            print('Run Unp');
            return HomeworkModel.fromJson(item);
          }).toList();
        } else {
          throw Exception('Data not found in response');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
  }


  Future<List<HomeworkModel>> getPubData({required String token}) async {
    print('pub');
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'operation': 'ShowHomework', 'status': "Published"}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      if (responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];
        return data.map((item) {
          return HomeworkModel.fromJson(item);
        }).toList();
      } else {
        throw Exception('Data not found in response');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
