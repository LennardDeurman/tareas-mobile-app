import 'package:tareas/models/abstract.dart';
import 'package:tareas/network/auth/header.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tareas/network/auth/service.dart';


class RequestHelper<T> {

  final Function(Map map) toObject;

  RequestHelper ({ this.toObject });

  static const Duration requestTimeout = Duration(seconds: 10);

  void validate(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception("Returned invalid status code with response body: " + response.body);
    }
  }

  Map<String, String> headers() {
    Map<String, String> allHeaders = Map<String, String>();
    allHeaders.addAll(AuthorizationHeader.map());
    if (AuthService().identityResult != null && AuthService().identityResult.activeMember != null) {
      allHeaders["OrganisationId"] = AuthService().identityResult.activeMember.organisation.id;
    }
    return allHeaders;
  }

  String encodeBody(body) {
    if (body is String) {
      return json.encode(body);
    } else if (body is Map) {
      return json.encode(body);
    }
    return null;
  }

  Future<List<T>> getAll(String url) async {
    var response = await http.get(url, headers: headers());
    validate(response);
    List items = json.decode(response.body);
    List<T> objects = [];
    if (items != null) {
      for (var item in items) {
        objects.add(toObject(item));
      }
      return objects;
    }
    return [];
  }

  Future<T> getSingle(String url) async {
    var response = await http.get(url, headers: headers());
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }

  Future<T> post(String url, { body }) async {
    var bodyStr = encodeBody(body);
    var hds = headers();
    hds["Content-Type"] = "application/json";
    var response = await http.post(url, body: bodyStr, headers: hds);
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }

  Future<T> put(String url, { body }) async {
    var response = await http.put(url, body: encodeBody(body), headers: headers());
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }

  Future<T> delete(String url) async {
    var response = await http.delete(url, headers: headers());
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }



}

class Host {

  static const String debugEnvironment = "https://tareas-acc-api.azurewebsites.net";
  static const String liveEnvironment = "https://tareas-prod-api.azurewebsites.net";

  static bool isDebug = false;

  static String get() {
    if (isDebug) {
      return debugEnvironment;
    } else {
      return liveEnvironment;
    }
  }

}


abstract class Fetcher<T extends ParsableObject> {

  RequestHelper<T> requestHelper;

  Fetcher () {
    this.requestHelper = createRequestHelper();
  }

  RequestHelper<T> createRequestHelper();

  static String urlWithQueryParams(String url, Map<String, String> queryMap) {
    Uri oldUri = Uri.parse(url);
    queryMap.addAll(oldUri.queryParameters);
    queryMap.removeWhere((String key, String value) {
      return value == null || value == "";
    });
    Uri newUri = Uri.https(oldUri.authority, oldUri.path, queryMap);
    return newUri.toString();
  }

  //Returns the current url
  String url (String path, { Map<String, String>  queryParams }) {
    String host = Host.get();
    String url = "$host/$path";
    if (queryParams != null) {
      url = urlWithQueryParams(url, queryParams);
    }
    return url; //String interpollation
  }



}

abstract class RestFetcher<T extends ParsableObject> extends Fetcher {

  Future<T> get(String id);

  Future<T> delete(String id);

  Future<List<T>> getAll();

  Future<T> post(T object);

  Future<T> put(T object);

}