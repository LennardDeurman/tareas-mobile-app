import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tareas/network/activities.dart';
import 'package:tareas/network/auth/service.dart';
import 'package:tareas/network/params.dart';









class TestOperation extends Operation {

  @override
  Completer executeOperation() {
    Completer completer = Completer();
    Future.delayed(Duration(seconds: 2), () {
      print("This action happened on: " + DateTime.now().toString());
      completer.complete();
    });
    return completer;
  }

}

void main() {

  test("Test multiple sync operation execution", () async {

    var testOperation = TestOperation();

    testOperation.execute();

    Future.delayed(Duration(seconds: 1), () {
      print(testOperation.operationInProgress);
      testOperation.execute();
    });


    Future.delayed(Duration(seconds: 3), () {
      print(testOperation.operationInProgress);
      testOperation.execute();
    });

    await Future.delayed(Duration(seconds: 7));
  });

  test("Date string", () async {

    initializeDateFormatting("nl");
    var value = NetworkParams.dateString(DateTime.now());
    print(value);

  });

}