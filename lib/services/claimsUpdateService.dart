import 'dart:async';

import 'package:expense_tracker/services/auth.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:flutter/cupertino.dart';

class ClaimsUpdateService extends ChangeNotifier {
  DatabaseMethods _databaseMethods;
  AuthMethods _authMethods;
  ClaimsUpdateService();

  ClaimsUpdateService.initialize(
      {DatabaseMethods databaseMethods, AuthMethods authMethods}) {
    _databaseMethods = databaseMethods;
    _authMethods = authMethods;
    if (_databaseMethods.userClaims() != null) {
      _userClaimsSubscription = _databaseMethods.userClaims().listen((val) {
        userClaims.value = val;
        notifyListeners();
        Future.delayed(Duration(seconds: 2))
            .then((_) => _databaseMethods.refreshIdTokens());
      });
    } else {
      print("Meh");
    }

    _userAuthSubscription = _authMethods.checkUserLogin.listen((user) {
      if (user == null) {
        print("Cancelling _userClaimsSubscription");
        _userClaimsSubscription.cancel();
      }
    });
  }

  ValueNotifier<Map<String, dynamic>> userClaims =
      ValueNotifier<Map<String, dynamic>>({"pinAuth": false, "counter": 0});

  StreamSubscription _userClaimsSubscription;
  StreamSubscription _userAuthSubscription;

  @override
  void dispose() {
    _userClaimsSubscription.cancel();
    _userAuthSubscription.cancel();
    super.dispose();
  }
}
