class UserModel {
  final int id;
  final String phoneNumber;
  final String email;
  final String name;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'email': email,
      'name': name,
    };
  }
}
