class UserModel {
  UserModel({this.name, this.email});
  final String? name;
  final String? email;

  UserModel.fromJson(Map<String, dynamic> json)
    : this(name: json['name'], email: json['email']);

  Map<String, dynamic> toJson() => {'name': name, 'email': email};
}
