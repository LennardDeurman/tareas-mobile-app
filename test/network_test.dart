import 'package:flutter_test/flutter_test.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/activities.dart';
import 'package:tareas/network/categories.dart';
import 'package:tareas/network/override_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';



void main() {

  test("Test category providers", () async {
    SharedPreferences.setMockInitialValues({
      CategoriesProvider.cachingKey: '[{id: fc73335e-a5af-4f13-befc-0a0270dfe3d0, name: Algemeen}, {id: 61c2d369-d314-4ff2-b1b3-0c6ccfe50a43, name: Kantine}, {id: e75d3d9e-6ceb-4ab1-9f05-4d924b6e9c7c, name: Goals}, {id: caa77969-3826-4357-8afb-a5cd2cc23626, name: Controle}, {id: 081afed0-0d7a-43b5-9130-e8b605b68bea, name: Arbitrage}]'
    });
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = new MyHttpOverrides();
    List<Category> categories = await CategoriesProvider().load();
    print(categories.map((e) => e.toMap()));
  });

  test("Get categories", () async {
    HttpOverrides.global = new MyHttpOverrides();
    CategoriesFetcher fetcher = CategoriesFetcher();
    var items = await fetcher.getAll();
    print(items.map((e) => e.toMap()));
  });


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