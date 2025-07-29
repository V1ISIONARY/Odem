import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:odem/backend/model/manga/reco.dart';
import 'package:odem/backend/properties/local_properties.dart';

class MangaRepository {

  final String endpoint = 'http://localhost:5000';
  final localProperties = LocalProperties();

  Future<List<RecoModel>> getRecommended() async {
    try {
      final response = await http.get(Uri.parse('$endpoint/experasyon/recommended'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['recommended_manga'] is List) {
          final recommend = data['recommended_manga'] as List;
          final parsedList = recommend.map((manga) => RecoModel.fromJson(manga)).toList();
          localProperties.recommendManga.value = parsedList;
          return parsedList;
        }
      }
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

}