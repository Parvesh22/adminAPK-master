class StaffAttd {
  final String status;
  final String name;

  StaffAttd({
    required this.status,
    required this.name,
  });

  factory StaffAttd.fromJson(List<dynamic> json) {
    return StaffAttd(
      name: json[0].toString(),
      status: json[1].toString(),
    );
  }
}
