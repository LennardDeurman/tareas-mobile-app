import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/categories.dart';

class CategoriesProvider {

  static const String cachingKey = "categoriesCachingKey";

  List<Category> _categories;

  List<Category> get categories {
    return _categories;
  }

  Future<List<Category>> _loadCachedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.get(CategoriesProvider.cachingKey);
    if (jsonString != null){
      try {
        List response = json.decode(jsonString);
        return response.map((e) => Category(e)).toList();
      } catch (e) {
        return null;
      }

    }
    return null;
  }

  Future _save(List<Category> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CategoriesProvider.cachingKey, json.encode(categories.map((e) => e.toMap()).toList()));
  }

  Future<List<Category>> _performLoad({ bool ignoreCache = false }) async {
    Completer<List<Category>> completer = Completer<List<Category>>();
    List<Category> cachedCategories;
    if (!ignoreCache)
      cachedCategories = await _loadCachedCategories();
    CategoriesFetcher fetcher = CategoriesFetcher();
    fetcher.getAll().then((categories) {
      _save(categories);
      completer.complete(categories);
    }).catchError((e) {
      if (cachedCategories != null) {
        completer.complete(cachedCategories);
      } else {
        completer.completeError(e);
      }
    });
    return completer.future;
  }

  Future<List<Category>> load({ bool ignoreCache = false, bool ignoreMemory = false }) async {
    if (_categories != null && !ignoreMemory) //Check if memory has the values
      return _categories;
    Future<List<Category>> categoriesFuture = _performLoad(ignoreCache: ignoreCache); //Check if cached or network
    _categories = await categoriesFuture;
    return categoriesFuture;
  }
}