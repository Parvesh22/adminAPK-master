class WeeklyTest {
  final String classSection;
  final String name;
  final String Subject;
  final String PhoneNo;

  WeeklyTest({
    required this.name,
    required this.classSection,
    required this.Subject,
    required this.PhoneNo
  });

  factory WeeklyTest.fromJson(List<dynamic> json) {
    return WeeklyTest(
      name: json[0].toString(),
      classSection : json[1].toString(),
      Subject: json[2].toString(),
      PhoneNo: json[3].toString(),
    );
  }
}
