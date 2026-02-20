
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/character.dart';

class RickApi {
  final _base = Uri.parse('https://rickandmortyapi.com/api');

  Future<List<Character>> getCharacters(int page) async {
    final uri = _base.replace(path: '/api/character', queryParameters: {'page': '$page'});
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Error ${res.statusCode} al cargar personajes');
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (json['results'] as List).cast<Map<String, dynamic>>();
    return results.map(Character.fromJson).toList();
  }
}
