class HomeworkModel {
  final String classSection;
  final String name;
  final String PhoneNo;

  HomeworkModel({
    required this.name,
    required this.classSection,
    required this.PhoneNo
  });

  factory HomeworkModel.fromJson(List<dynamic> json) {
    return HomeworkModel(
      name: json[0] == null ? "" : json[0],
      classSection : json[1] == null ? "" : json[1],
      PhoneNo: json[1] == null ? "" : json[1],
    );
  }
}
