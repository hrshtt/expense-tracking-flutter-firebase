import 'package:expense_tracker/core/models/expenseModel.dart';
import 'package:flutter/cupertino.dart';

class ChatBoxElement {
  final Expense expense;
  final bool expenseFromAuthor;
  // final Map<String, Color> userDisplayColor;

  const ChatBoxElement({
    @required this.expense,
    @required this.expenseFromAuthor,
    // @required this.userDisplayColor,
  });
}
