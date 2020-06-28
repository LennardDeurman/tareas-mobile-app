import 'package:flutter_test/flutter_test.dart';
import 'package:tareas/network/activities.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {

  test("Get open activities", () async {
    HttpOverrides.global = new MyHttpOverrides();
    ActivitiesFetcher fetcher = ActivitiesFetcher();
    var items = await fetcher.getOpenActivities();
    print(items.map((e) => e.toMap()));
  });

  test("Get single activity", () async {
    HttpOverrides.global = new MyHttpOverrides();
    ActivitiesFetcher fetcher = ActivitiesFetcher();
    var item = await fetcher.get("fd15ed98-4c8a-44cd-ab75-26021420d9fc");
    print(item.toMap());
  });


  test("Test local server", () async {
    HttpOverrides.global = new MyHttpOverrides();
    var response = await http.get("https://localhost:44339/openActivities");
    print(response.body);

  });

}