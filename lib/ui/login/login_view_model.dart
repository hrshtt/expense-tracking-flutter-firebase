import 'package:flutter/widgets.dart';
import 'package:expense_tracker/services/auth.dart';
import 'package:expense_tracker/core/enums/viewstate.dart';

import '../base_model.dart';

class LoginViewModel extends BaseModel {
  AuthMethods _authenticationService;

  LoginViewModel({
    @required AuthMethods authenticationService,
  }) : _authenticationService = authenticationService;

  Future<bool> login(
      {@required String email, @required String password}) async {
    setState(ViewState.Busy);
    // var userId = int.tryParse(userIdText);
    bool success = await _authenticationService.signInWithEmailAndPassword(
        email: email, password: password);
    setState(ViewState.Idle);
    return success;
  }
}
