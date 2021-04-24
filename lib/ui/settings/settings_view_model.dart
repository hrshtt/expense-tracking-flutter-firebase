// import 'package:expense_tracker/services/cloudFunctions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:expense_tracker/core/enums/viewstate.dart';
// import 'package:expense_tracker/services/auth.dart';

import 'package:expense_tracker/services/auth.dart';
import 'package:flutter/widgets.dart';
import '../base_model.dart';

class SettingsViewModel extends BaseModel {
  AuthMethods _authMethods;
  // Stream<User> _userChanges;

  SettingsViewModel({
    @required AuthMethods authMethods,
  }) : _authMethods = authMethods;

  Future<void> logout() async {
    await _authMethods.logout();
  }
}
