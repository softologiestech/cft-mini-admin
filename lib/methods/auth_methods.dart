import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> login(String username, String password) {
    return _auth.signInWithEmailAndPassword(
        email: username + '@cftusd.com', password: password);
  }

  Future<UserCredential> register(String username, String password) {
    return _auth.createUserWithEmailAndPassword(
        email: username + '@cftusd.com', password: password);
  }

  User? currentUser() {
    return _auth.currentUser;
  }

  Future<http.Response> deleteUser(String uid) {
    var url = Uri.parse(
        'https://us-central1-cft-usd-c31bb.cloudfunctions.net/deleteUser?uid=$uid');
    var res = http.get(url);

    return res;
  }

  Future logout() {
    return _auth.signOut();
  }
}
