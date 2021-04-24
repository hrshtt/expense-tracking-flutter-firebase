import 'package:flutter/widgets.dart';
import 'package:expense_tracker/services/auth.dart';
// import 'package:expense_tracker/core/enums/viewstate.dart';

import '../base_model.dart';

class SplashViewModel extends BaseModel {
  AuthMethods _authenticationService;

  SplashViewModel({
    @required AuthMethods authenticationService,
  }) : _authenticationService = authenticationService;

  bool get loggedin => _authenticationService.user != null;
}
