import 'package:expense_tracker/services/claimsUpdateService.dart';
import 'package:flutter/widgets.dart';
import 'package:expense_tracker/ui/base_model.dart';

class ChatPageViewModel extends BaseModel {
  ClaimsUpdateService _claimsUpdateService;

  ChatPageViewModel({
    @required ClaimsUpdateService claimsUpdateService,
  }) : _claimsUpdateService = claimsUpdateService;

  bool get isUserPinAuthorized =>
      _claimsUpdateService.userClaims.value["pinAuth"];

  void rebuildUI() {
    if (!isUserPinAuthorized) {
      notifyListeners();
    }
  }
}
