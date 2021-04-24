import 'package:expense_tracker/core/models/chatModel.dart';
import 'package:expense_tracker/ui/shared/date_styles.dart' as _timeFormats;
import 'package:expense_tracker/ui/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatContainer extends StatelessWidget {
  const ChatContainer({
    Key key,
    @required ChatBoxElement chatBoxElement,
  })  : _chatBoxElement = chatBoxElement,
        super(key: key);

  final ChatBoxElement _chatBoxElement;

  static const Map<String, dynamic> iconsUtil = {
    "Invoice": MdiIcons.fileDocument,
    "Reciept": Icons.receipt,
    "Order-Book": MdiIcons.bookAccount,
    "Cash": MdiIcons.cash,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        mainAxisAlignment: (_chatBoxElement.expenseFromAuthor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...(_chatBoxElement.expenseFromAuthor
              ? [SizedBox.shrink()]
              : [
                  CircleAvatar(
                    child: Text(
                      _chatBoxElement.expense.addedByUser.uniqueInitials,
                      style: TextStyle(
                          color: Color(0xfff8fbff),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    backgroundColor: Color(0xff84c1ff),
                  ),
                  const SizedBox(width: 8),
                ]),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: (_chatBoxElement.expenseFromAuthor
                    ? Color(0xffd6eaff)
                    : Color(0xff84c1ff)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text(_expense.addedByName),
                      Icon(
                        iconsUtil[_chatBoxElement.expense.amountType],
                        color: (_chatBoxElement.expenseFromAuthor
                            ? Colors.black54
                            : Colors.white),
                      ),
                      _chatBoxElement.expense.pendingStatus
                          ? Text(
                              " DUE",
                              style: TextStyle(
                                  color: Colors.red[600],
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              " Paid",
                              style: TextStyle(
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.bold),
                            ),
                      Spacer(),
                      Text(
                        _timeFormats.formattedTime(
                            _chatBoxElement.expense.creationDateTime.toDate()),
                        style: TextStyle(
                            fontSize: 12,
                            color: _chatBoxElement.expenseFromAuthor
                                ? Colors.black54
                                : Colors.white70),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _chatBoxElement.expense.amountType,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            wordSpacing: 1,
                            color: (_chatBoxElement.expenseFromAuthor
                                ? Colors.grey[800]
                                : Colors.white)),
                      ),
                      Visibility(
                        child: Text(
                          " No. ${_chatBoxElement.expense.paymentRefrence}",
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              wordSpacing: 1,
                              color: (_chatBoxElement.expenseFromAuthor
                                  ? Colors.grey[800]
                                  : Colors.white)),
                        ),
                        replacement: SizedBox.shrink(),
                        visible:
                            (_chatBoxElement.expense.paymentRefrence != null),
                      ),
                      Spacer(),
                      Text(
                        (_chatBoxElement.expense.credited
                            ? "Recieved by "
                            : "Paid by "),
                        style: TextStyle(
                            wordSpacing: 1,
                            color: _chatBoxElement.expenseFromAuthor
                                ? Colors.black54
                                : Colors.white70),
                      ),
                      Text(_chatBoxElement.expense.transcByUser.displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              wordSpacing: 1,
                              fontSize: 16,
                              color: (_chatBoxElement.expenseFromAuthor
                                  ? Colors.grey[800]
                                  : Colors.white))),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: (_chatBoxElement.expense.credited
                              ? Colors.green
                              : Colors.red)),
                      borderRadius: BorderRadius.circular(3),
                      color: (_chatBoxElement.expense.credited
                          ? Colors.green[50]
                          : Colors.red[50]),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _chatBoxElement.expense.supText,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          "\u{20B9}${_chatBoxElement.expense.amount}",
                          style: coolTextStyle,
                        ),
                        (_chatBoxElement.expense.credited
                            ? Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.redAccent[400],
                              )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          (_chatBoxElement.expenseFromAuthor
                              ? "You"
                              : _chatBoxElement
                                  .expense.addedByUser.displayName),
                          style: TextStyle(
                              color: _chatBoxElement.expenseFromAuthor
                                  ? Colors.black54
                                  : Colors.white70)),
                      Text(
                        _timeFormats.timeAgoTime(
                            _chatBoxElement.expense.creationDateTime.toDate()),
                        style: TextStyle(
                            fontSize: 10,
                            color: _chatBoxElement.expenseFromAuthor
                                ? Colors.black54
                                : Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ...(!_chatBoxElement.expenseFromAuthor
              ? [const SizedBox.shrink()]
              : [
                  const SizedBox(width: 8),
                  CircleAvatar(
                    child: Text(
                      _chatBoxElement.expense.addedByUser.uniqueInitials,
                      style: TextStyle(
                          color: Color(0xff3b7dd8),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    backgroundColor: Color(0xffd6eaff),
                  )
                ]),
        ],
      ),
    );
  }
}
