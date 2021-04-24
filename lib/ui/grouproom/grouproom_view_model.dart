// import 'package:expense_tracker/services/auth.dart';
// import 'package:expense_tracker/services/auth.dart';import 'package:expense_tracker/core/enums/viewstate.dart';
import 'dart:async';

import 'package:expense_tracker/core/enums/viewstate.dart';
import 'package:expense_tracker/services/claimsUpdateService.dart';
import 'package:expense_tracker/services/cloudFunctions.dart';
import 'package:flutter/widgets.dart';

import '../base_model.dart';

class GroupRoomModel extends BaseModel {
  CallableFunctions _callableFunctions;
  ClaimsUpdateService _claimsUpdateService;

  GroupRoomModel({
    @required CallableFunctions callableFunctions,
    @required ClaimsUpdateService claimsUpdateService,
  })  : _callableFunctions = callableFunctions,
        _claimsUpdateService = claimsUpdateService;

  bool get isUserPinAuthorized =>
      _claimsUpdateService.userClaims.value["pinAuth"];

  Future<void> pinUnauth() async {
    setState(ViewState.Busy);
    await _callableFunctions
        .checkPinAuth("", reset: true)
        .then((_) => true)
        .catchError((err) => false);
    setState(ViewState.Idle);
  }

  void rebuildUI() {
    if (isUserPinAuthorized) {
      print("rebuildUI: iamRunning");
      notifyListeners();
    }
  }
}
