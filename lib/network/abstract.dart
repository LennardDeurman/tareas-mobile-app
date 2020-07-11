import 'package:tareas/models/abstract.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestHelper<T> {

  final Function(Map map) toObject;

  RequestHelper ({ this.toObject });

  static const Duration requestTimeout = Duration(seconds: 5);

  void validate(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception("Returned invalid status code with response body: " + response.body);
    }
  }

  Future<List<T>> getAll(String url) async {
    var response = await http.get(url).timeout(requestTimeout);
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
    var response = await http.get(url).timeout(requestTimeout);
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }

  Future<T> post(String url, { Map body }) async {
    var response = await http.post(url, body: json.encode(body)).timeout(requestTimeout);
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }

  Future<T> put(String url, { Map body }) async {
    var response = await http.put(url, body: json.encode(body)).timeout(requestTimeout);
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }



}


abstract class Fetcher<T extends ParsableObject> {

  static const String host = "https://192.168.1.234:44339";

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
  String url (String path, { Map queryParams }) {
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