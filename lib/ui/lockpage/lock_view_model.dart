import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/services/claimsUpdateService.dart';
import 'package:expense_tracker/services/cloudFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../base_model.dart';

class LockViewModel extends BaseModel {
  CallableFunctions _callableFunctions;

  LockViewModel(
      {@required CallableFunctions callableFunctions,
      @required ClaimsUpdateService claimsUpdateService,
      // @required ValueNotifier<Map<String, dynamic>> userClaims,
      this.maxWidth}) {
    // print("model was built ${userClaims.value}");
    _claimsUpdateService = claimsUpdateService;
    _callableFunctions = callableFunctions;
    // _userClaims = _claimsUpdateService.userClaims.value;
    progressBarWidth =
        (maxWidth / 3) * _claimsUpdateService.userClaims.value["counter"];
    progressBarColor = Colors.black12;
  }

  // Map<String, dynamic> _userClaims;
  ClaimsUpdateService _claimsUpdateService;
  double progressBarWidth;
  Color progressBarColor;
  final double maxWidth;
  bool _displayWarning = false;
  bool get displayWarning => _displayWarning;

  void printValue() {
    print("Values from printValue ${_claimsUpdateService.userClaims.value}");
  }

  Future<bool> pinAuth({@required String pin}) async {
    // _databaseMethods.listenForUserChanges();
    setState(ViewState.Busy);
    print("Values from pinAuth $_claimsUpdateService.userClaims.value");
    bool success = await _callableFunctions.checkPinAuth(pin);

    if (_claimsUpdateService.userClaims.value["counter"] >= 3) {
      _displayWarning = true;
    }

    setState(ViewState.Idle);
    print("Values from pinAuth again $_claimsUpdateService.userClaims.value");
    return success;
  }

  void resetProgressBar() {
    progressBarWidth = 0.0;
    // notifyListeners();
  }

  void updateProgressBar(bool success) {
    if (success) {
      progressBarColor = Colors.green;
      progressBarWidth = maxWidth;
    } else {
      progressBarColor = Colors.red;
      progressBarWidth =
          (maxWidth / 3) * _claimsUpdateService.userClaims.value["counter"];
    }
  }

  // void userListener() {
  //   _databaseMethods.listenForUserChanges();
  // }
}
