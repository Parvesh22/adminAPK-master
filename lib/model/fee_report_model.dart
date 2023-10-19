class ExamModel {
  final String ClassSection;
  final String PendingAmt;
  final String PendingStd;
  final String? TotalStd;

  ExamModel({
    required this.ClassSection,
    required this.PendingAmt,
    required this.PendingStd,
    this.TotalStd,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      ClassSection: json['ClassSection'] as String,
      PendingAmt: json['PendingAmount'] as String,
      PendingStd: json['PendingStd'] as String,
      TotalStd: json['TotalStd'] as String?,
    );
  }
}
