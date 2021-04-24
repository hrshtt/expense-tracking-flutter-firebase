import 'package:cloud_functions/cloud_functions.dart';

class CallableFunctions {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<bool> checkPinAuth(String pin, {bool reset: false}) async {
    _functions.useFunctionsEmulator(
        origin:
            'https://asia-south1-expense-tracker-app-16b0d.cloudfunctions.net/addPinAuth');

    HttpsCallable getPinAuth = _functions.httpsCallable('addPinAuth');

    return await getPinAuth({'pin': pin, 'reset': reset})
        .then((HttpsCallableResult result) {
      // print("Pin Auth Call res:\Data: ${result.data}");
      return result.data["pinAuth"];
    }).catchError((err) => {print("Error httpcallback mai $err")});
  }

  // Future<void> initCustomClaim() async {
  //   _functions.useFunctionsEmulator(origin: 'http://localhost:5001');

  //   HttpsCallable addPinAuth = _functions.httpsCallable('initCustomClaim');
  //   await addPinAuth()
  //       .catchError((err) => {print("Error httpcallback mai $err")});

  //   // print("Ye lo function ke results ${results.data}");
  //   // List fruit = results.data;  // ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
  // }
}
