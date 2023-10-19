class HomeModel {
  final String status;
  final String name;

  HomeModel({
    required this.status,
    required this.name,
  });

  factory HomeModel.fromJson(List<dynamic> json) {
    return HomeModel(
      name: json[0] as String,
      status: json[1] as String,
    );
  }
}
