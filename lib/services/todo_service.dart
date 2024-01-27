import 'package:http/http.dart' as http;
import 'dart:convert';

class ToDoService {
  static Future<List?> fetchToDo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=20';
    final uri = Uri.parse(url);
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map;
      return json['items'] as List;
    } else {
      return null;
    }
  }

  static Future<bool> createToDo(Map body) async {
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final res = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return res.statusCode == 201;
  }

  static Future<bool> updateToDoById(String id, Map body) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final res = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return res.statusCode == 200;
  }

  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final res = await http.delete(uri);
    return res.statusCode == 200;
  }
}