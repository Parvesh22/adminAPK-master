class StudentAttd {
  final String status;
  final String name;
  final String classSection;

  StudentAttd({
    required this.status,
    required this.name,
    required this.classSection,
  });

  factory StudentAttd.fromJson(List<dynamic> json) {
    return StudentAttd(
      status: json[0] as String,
      name: json[1] as String,
      classSection: json[2] as String,
    );
  }
}
