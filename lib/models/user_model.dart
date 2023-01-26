class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? image;
  final String? role;

  UserModel({this.id, this.name, this.email, this.image, this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: json['image'] ?? '',
      role: json['role']);
}
