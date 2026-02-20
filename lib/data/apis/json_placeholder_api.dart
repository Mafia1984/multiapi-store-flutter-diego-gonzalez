
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/post.dart';

class JsonPlaceholderApi {
  final _base = Uri.parse('https://jsonplaceholder.typicode.com');

  Future<List<Post>> getPosts({int limit = 10}) async {
    final uri = _base.replace(path: '/posts', queryParameters: {'_limit': '$limit'});
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Error ${res.statusCode} al cargar posts');
    final list = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    return list.map(Post.fromJson).toList();
    }
}
