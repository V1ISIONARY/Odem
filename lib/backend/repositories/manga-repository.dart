import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MangaRepository {
  final String? endpoint = dotenv.env['ENDPOINT'];
  final String? key = dotenv.env['INIKEY'];
  final localProperties = LocalProperties();

  Future<String> getMangaRoot() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('mangaRoot') ?? "asura-scans";
    // return prefs.getString('sysExtension') ?? localProperties.sysExtension.value;
  }

  Future<List<Extension>> fetchExtensions() async {
    final response = await http.get(Uri.parse('$endpoint/extension/data?lock=$key'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> extensionsJson = data['extensions'];
      final extensions = extensionsJson.map((json) => Extension.fromJson(json)).toList();

      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(extensions.map((e) => e.toJson()).toList());
      await prefs.setString('extensions_data', jsonString);

      localProperties.extensions.value = extensions;
      return extensions;
    } else {
      throw Exception('Failed to load extensions');
    }
  }
  
  Future<List<RecoModel>> getRecommended() async {
    try {
      final mangaRoot = await getMangaRoot();
      final response = await http.get(Uri.parse('$endpoint/manga/$mangaRoot/recommend?lock=$key'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] is List) {
          final recommend = data['result'] as List;

          final parsedList = recommend.map((manga) => RecoModel.fromJson(manga)).toList();
          final prefs = await SharedPreferences.getInstance();
          final jsonString = json.encode(parsedList.map((e) => e.toJson()).toList());
          await prefs.setString('recommended_manga', jsonString);

          localProperties.recommendManga.value = parsedList;
          return parsedList;
        }
      }
      return [];
    } catch (e) {
      print("Error fetching recommended manga: $e");
      return [];
    }
  }

  Future<List<RecoModel>> InstallExtension(String source) async {
    try {
      final response = await http.get(Uri.parse('$endpoint/manga/$source/recommend?lock=$key'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] is List) {
          final recommend = data['result'] as List;
          final parsedList = recommend.map((manga) => RecoModel.fromJson(manga)).toList();

          print('Source: $source, parsedList count: ${parsedList.length}');

          final prefs = await SharedPreferences.getInstance();
          final existingJson = prefs.getString('migrationData');
          Map<String, List<RecoModel>> existingData = {};

          if (existingJson != null && existingJson.isNotEmpty) {
            final decoded = jsonDecode(existingJson) as Map<String, dynamic>;
            existingData = decoded.map(
              (key, list) => MapEntry(
                key,
                (list as List).map((item) => RecoModel.fromJson(item)).toList(),
              ),
            );
          }

          const int maxItemsPerSource = 100;

          if (existingData.containsKey(source)) {
            final existingList = existingData[source]!;

            final newUnique = parsedList.where(
              (newItem) => !existingList.any((oldItem) => oldItem.mangaid == newItem.mangaid)
            ).toList();

            existingList.addAll(newUnique);

            // Keep only the last maxItemsPerSource items
            if (existingList.length > maxItemsPerSource) {
              existingData[source] = existingList.sublist(existingList.length - maxItemsPerSource);
            } else {
              existingData[source] = existingList;
            }
          } else {
            existingData[source] = parsedList.length > maxItemsPerSource
              ? parsedList.sublist(0, maxItemsPerSource)
              : parsedList;
          }

          localProperties.migrationData.value = existingData;

          existingData.forEach((key, list) {
            print('MigrationData source: $key, item count: ${list.length}');
          });

          final migrationDataJson = existingData.map(
            (key, list) => MapEntry(
              key,
              list.map((reco) => reco.toJson()).toList(),
            ),
          );
          await prefs.setString('migrationData', jsonEncode(migrationDataJson));

          return parsedList;
        }
      }
      return [];
    } catch (e) {
      print("Error fetching recommended manga: $e");
      return [];
    }
  }

  Future<List<MangaImgModel>> fetchMangaImages(String seriesPath) async {
    final mangaRoot = await getMangaRoot();
    if (localProperties.mangaImg.value.isNotEmpty) {
      return localProperties.mangaImg.value;
    }
    final url = Uri.parse('$endpoint/manga/$mangaRoot/reader/$seriesPath?lock=$key');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load manga images, status: ${response.statusCode}');
    }
    final data = json.decode(response.body);
    if (data['images'] == null || (data['images'] as List).isEmpty) {
      throw Exception('No images found in response');
    }
    final parsedList = (data['images'] as List<dynamic>)
      .map((imgUrl) => MangaImgModel.fromJson(imgUrl))
      .toList();
    localProperties.mangaImg.value = parsedList;

    return parsedList;
  }

}