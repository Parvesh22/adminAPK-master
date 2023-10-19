class ExamModel {
  final String ClassSection;
  final String exam;
  final String subject;
  final String? ClassIncharge;
  final String? PhoneNo;

  ExamModel({
    required this.ClassSection,
    required this.exam,
    required this.subject,
    this.ClassIncharge,
    this.PhoneNo,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      ClassSection: json['ClassSection'] as String,
      exam: json['Exam'] as String,
      subject: json['Subject'] as String,
      ClassIncharge: json['ClassIncharge'] as String?,
      PhoneNo: json['PhoneNo'] as String?,
    );
  }
}
