import 'dart:convert';

class ManagerModel {
  String name;
  String email;
  String password;
  String username;
  String uid;
  num amount;

  ManagerModel({
    required this.name,
    required this.email,
    required this.password,
    required this.username,
    required this.uid,
    required this.amount,
  });

  ManagerModel copyWith({
    String? name,
    String? email,
    String? password,
    String? username,
    String? uid,
    num? amount,
  }) {
    return ManagerModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'username': username,
      'uid': uid,
      'amount': amount,
    };
  }

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      amount: map['amount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ManagerModel.fromJson(String source) =>
      ManagerModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ManagerModel(name: $name, email: $email, password: $password, username: $username, uid: $uid, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ManagerModel &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.username == username &&
        other.uid == uid &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        amount.hashCode;
  }
}
