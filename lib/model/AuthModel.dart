
class AuthModel{

    final String name;
    final String password;
    final String token;

    AuthModel({required this.name, required this.password, required this.token });

    factory AuthModel.fromJson(Map<String, dynamic> json) {
        return AuthModel(
            name: json['name'],
            password: json['password'],
            token: json['token']
        );
    }

    gettoken(){
        print(token);
    }

}