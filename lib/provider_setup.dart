import 'package:expense_tracker/core/models/expenseModel.dart';
import 'package:expense_tracker/core/models/safeLocalUser.dart';
import 'package:expense_tracker/services/auth.dart';
import 'package:expense_tracker/services/claimsUpdateService.dart';
import 'package:expense_tracker/services/cloudFunctions.dart';
import 'package:expense_tracker/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: AuthMethods()),
  Provider.value(value: CallableFunctions()),
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<AuthMethods, DatabaseMethods>(
    update: (BuildContext context, AuthMethods authService,
            DatabaseMethods databaseService) =>
        DatabaseMethods(auth: authService),
  ),
  ChangeNotifierProxyProvider2<DatabaseMethods, AuthMethods,
      ClaimsUpdateService>(
    create: (_) => ClaimsUpdateService(),
    update: (BuildContext context, DatabaseMethods databaseMethods,
            AuthMethods authMethods, ClaimsUpdateService claimsUpdateService) =>
        ClaimsUpdateService.initialize(
            databaseMethods: databaseMethods, authMethods: authMethods),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<List<SafeLocalUser>>(
    initialData: null,
    create: (context) =>
        Provider.of<DatabaseMethods>(context, listen: false).usersStream,
    updateShouldNotify: (_, __) => true,
  ),
  StreamProvider<List<Expense>>(
    initialData: [],
    create: (context) =>
        Provider.of<DatabaseMethods>(context, listen: false).expenseStream,
    updateShouldNotify: (_, __) => true,
  ),

  // StreamProvider<Map<String, dynamic>>(
  //   initialData: {"pinAuth": false, "counter": 0},
  //   create: (context) {
  //     return context.read<DatabaseMethods>().userClaims;
  //   },
  // ),
  // ChangeNotifierProvider<ValueNotifier<Map<String, dynamic>>>(
  //   create: (context) =>
  //       Provider.of<DatabaseMethods>(context, listen: false).pinAuth,
  // ),
];
