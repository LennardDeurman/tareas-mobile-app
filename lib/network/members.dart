import 'package:tareas/network/abstract.dart';
import 'package:tareas/models/member.dart';

class MembersFetcher extends RestFetcher<Member> {

  @override
  RequestHelper<Member> createRequestHelper() {
    return RequestHelper<Member>(toObject: (Map map) {
      return Member(map);
    });
  }

  @override
  Future<Member> get(String id) async {
    return await this.requestHelper.getSingle(url("members/$id"));
  }

  @override
  Future<Member> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Member>> getAll() {
    return this.requestHelper.getAll(url("members"));
  }

  @override
  Future<Member> post(Member object) {
    return this.requestHelper.post(url("members"), body: object.toMap());
  }

  @override
  Future<Member> put(Member object) {
    return this.requestHelper.put(url("members/${object.id}"), body: object.toMap());
  }

}