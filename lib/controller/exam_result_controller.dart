import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/exam_result_model.dart';

class ExamController {
  final String apiUrl =
      'https://ddemo.xscholar.com/sms/api/adminapp/examresult.php?'; // Replace with your API endpoint

  Future<List<ExamModel>> getExamData(
      {required String token, required String type}) async {
    final response = await http.post(
      Uri.parse('$apiUrl'),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'operation': 'ExamResult', 'status': type}),
    );

    print(type);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];
        return data.map((item) {
          return ExamModel.fromJson(item);
        }).toList();
      } else {
        throw Exception('Data not found in response');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}