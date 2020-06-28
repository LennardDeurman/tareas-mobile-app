import 'package:tareas/models/abstract.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestHelper<T> {

  final Function(Map map) toObject;

  RequestHelper ({ this.toObject });

  void validate(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception("Returned invalid status code with response body: " + response.body);
    }
  }

  Future<List<T>> getAll(String url) async {
    var response = await http.get(url);
    validate(response);
    var items = json.decode(response.body);
    print(items);
    return [];
  }

  Future<T> getSingle(String url) async {
    var response = await http.get(url);
    validate(response);
    Map map = json.decode(response.body);
    return toObject(map);
  }




}


abstract class Fetcher<T extends ParsableObject> {

  static const String host = "https://localhost:44339";

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