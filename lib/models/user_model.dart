import 'dart:convert';

class UserModel {
  String name;
  String username;
  String email;
  String uid;
  String password;
  num equity;
  num amount;
  num free_margin;
  num margin;
  num commission;
  num net_commission;

  UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.uid,
    required this.password,
    required this.equity,
    required this.amount,
    required this.free_margin,
    required this.margin,
    required this.commission,
    required this.net_commission,
  });

  UserModel copyWith({
    String? name,
    String? username,
    String? email,
    String? uid,
    String? password,
    num? equity,
    num? amount,
    num? free_margin,
    num? margin,
    num? commission,
    num? net_commission,
  }) {
    return UserModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      password: password ?? this.password,
      equity: equity ?? this.equity,
      amount: amount ?? this.amount,
      free_margin: free_margin ?? this.free_margin,
      margin: margin ?? this.margin,
      commission: commission ?? this.commission,
      net_commission: net_commission ?? this.net_commission,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'uid': uid,
      'password': password,
      'equity': equity,
      'amount': amount,
      'free_margin': free_margin,
      'margin': margin,
      'commission': commission,
      'net_commission': net_commission,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      username: map['username'],
      email: map['email'],
      uid: map['uid'],
      password: map['password'],
      equity: map['equity'],
      amount: map['amount'],
      free_margin: map['free_margin'],
      margin: map['margin'],
      commission: map['commission'],
      net_commission: map['net_commission'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, username: $username, email: $email, uid: $uid, password: $password, equity: $equity, amount: $amount, free_margin: $free_margin, margin: $margin, commission: $commission, net_commission: $net_commission)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.uid == uid &&
        other.password == password &&
        other.equity == equity &&
        other.amount == amount &&
        other.free_margin == free_margin &&
        other.margin == margin &&
        other.commission == commission &&
        other.net_commission == net_commission;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        password.hashCode ^
        equity.hashCode ^
        amount.hashCode ^
        free_margin.hashCode ^
        margin.hashCode ^
        commission.hashCode ^
        net_commission.hashCode;
  }
}
