import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/media.dart';

class ApiService {
  static const String baseURL = 'http://netflixclone.mywebcommunity.org';
  static Future<void> saveUserList(String userId, List<Media> mediaList) async {
    final url = Uri.parse('$baseURL/save_list.php');
    final mediaIds = mediaList.map((media) => media.id).join(',');

    final response = await http.post(
      url,
      body: {
        'user_id': userId,
        'media_ids': mediaIds,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user list');
    }
  }

  static Future<List<String>> getUserList(String userId) async {
    final url = Uri.parse('$baseURL/get_list.php?user_id=$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> mediaIds = json.decode(response.body);
      return mediaIds.cast<String>();
    } else {
      throw Exception('Failed to get user list');
    }
  }
}
