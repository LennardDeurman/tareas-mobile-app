import 'dart:async';
import 'package:tareas/models/account.dart';
import 'package:tareas/network/abstract.dart';

class AccountFetcher extends RestFetcher<Account> {

  @override
  RequestHelper<Account> createRequestHelper() {
    return RequestHelper<Account>(toObject: (Map map) {
      return Account(map);
    });
  }

  @override
  Future<Account> post(Account object) {
    throw UnimplementedError();
  }

  @override
  Future<Account> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Account> get(String id) {
    return requestHelper.getSingle(url("accounts/id"));
  }

  @override
  Future<Account> put(Account object) {
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> getAll() async {
    throw UnimplementedError();
  }


}