// import 'package:expense_tracker/ui/shared/text_styles.dart';
// import 'package:flutter/material.dart';

// class LockKeypad extends StatelessWidget {
//   const LockKeypad({Key key, @required this.controller}) : super(key: key);
//   final TextEditingController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           DigitButton(digit: "1", controller: controller),
//           DigitButton(digit: "2", controller: controller),
//           DigitButton(digit: "3", controller: controller),
//         ],
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           DigitButton(digit: "4", controller: controller),
//           DigitButton(digit: "5", controller: controller),
//           DigitButton(digit: "6", controller: controller),
//         ],
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           DigitButton(digit: "7", controller: controller),
//           DigitButton(digit: "8", controller: controller),
//           DigitButton(digit: "9", controller: controller),
//         ],
//       )
//     ]);
//   }
// }

// class DigitButton extends StatelessWidget {
//   DigitButton({Key key, @required this.digit, @required this.controller})
//       : super(key: key);

//   final String digit;
//   final TextEditingController controller;
//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       child: Text(
//         digit,
//         style: keypadTextStyle,
//       ),
//       onPressed: () => {
//         controller.text = controller.text + digit,
//       },
//       padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//     );
//   }
// }
