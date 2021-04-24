import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User get user => _auth.currentUser;
  String get safeUserID {
    var uid = _auth.currentUser.uid;
    return uid.substring(uid.length - 7);
  }

  Stream<User> get checkUserLogin => _auth.userChanges();

  Future<Map<String, dynamic>> refreshTokenIds() async {
    print("refreshing ID Tokens");
    if (FirebaseAuth.instance.currentUser != null) {
      var data = await FirebaseAuth.instance.currentUser.getIdTokenResult(true);
      print("token claims ${data.claims}");
      return data.claims;
    } else {
      return {"pinAuth": false, "counter": 0};
    }
  }

  Future<bool> signInWithEmailAndPassword(
      {String email, String password}) async {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((_) => true)
        .catchError((err) {
      print("Caught Error in signInWithEmailAndPassword!");
      print(err);
    });
  }

  Future<void> logout() async {
    print("Logging Out User ${_auth.currentUser.email}");
    await _auth.signOut();
  }
}
