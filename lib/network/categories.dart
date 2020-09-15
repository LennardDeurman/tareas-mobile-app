import 'dart:async';
import 'package:tareas/models/category.dart';
import 'package:tareas/network/abstract.dart';

class CategoriesFetcher extends RestFetcher<Category> {

  @override
  RequestHelper<Category> createRequestHelper() {
    return RequestHelper<Category>(toObject: (Map map) {
      return Category(map);
    });
  }

  @override
  Future<Category> post(Category object) {
    throw UnimplementedError();
  }

  @override
  Future<Category> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Category> get(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Category> put(Category object) {
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> getAll() async {
    return await this.requestHelper.getAll(url("taskCategories"));
  }


}