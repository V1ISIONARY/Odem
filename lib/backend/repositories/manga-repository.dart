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
    return prefs.getString('mangaRoot') ?? "";
    //return prefs.getString('sysExtension') ?? localProperties.sysExtension.value;
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

  Future<List<RecoModel>> InstallExtension(String source, bool fromExt) async {
  try {
    final response = await http.get(Uri.parse('$endpoint/manga/$source/recommend?lock=$key'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] is List) {
        final recommend = data['result'] as List;
        final parsedList = recommend
            .map((manga) => RecoModel.fromJson(manga))
            .where((manga) => manga.chapterdetails.isNotEmpty)
            .toList();

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

        List<RecoModel> existingList = existingData[source] ?? [];
        Map<String, RecoModel> existingMap = {for (var item in existingList) item.title: item};

        for (var newItem in parsedList) {
          if (existingMap.containsKey(newItem.title)) {
            final existingItem = existingMap[newItem.title]!;
            Map<String, ChapterDetail> chapterMap = {for (var ch in existingItem.chapterdetails) ch.link: ch};
            for (var newChapter in newItem.chapterdetails) {
              chapterMap[newChapter.link] = newChapter;
            }
            existingItem.chapterdetails = chapterMap.values.toList();
            existingItem.rating = newItem.rating;
          } else {
            existingMap[newItem.title] = newItem;
          }
        }

        final mergedList = existingMap.values.toList();
        existingData[source] = mergedList;
        localProperties.migrationData.value = Map<String, List<RecoModel>>.from(existingData);

        // Only update recommendManga if not from extension
        if (!fromExt) {
          localProperties.recommendManga.value = mergedList;
        }

        // Save the full data including chapterdetails
        final fullDataJson = existingData.map(
          (key, list) => MapEntry(
            key,
            list.map((reco) => reco.toJson()).toList(),
          ),
        );
        await prefs.setString('migrationData', jsonEncode(fullDataJson));

        return existingData[source] ?? [];
      }
    }
    return [];
  } catch (e) {
    print("Error fetching recommended manga: $e");
    return [];
  }
}

  Future<List<RecoModel>> searchManga(String title, String extKey, bool isSearch) async {
    try {
      final localProperties = LocalProperties();
      final response = await http.get(
        Uri.parse('$endpoint/manga/$extKey/search?name=$title&lock=$key'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] is List) {
          final recommend = data['result'] as List;
          final parsedList = recommend.map((manga) => RecoModel.fromJson(manga)).toList();

          final currentMap = localProperties.searchManga.value;
          final updatedMap = currentMap.map((source, typeMap) {
            return MapEntry(
              source,
              typeMap.map((typeKey, list) => MapEntry(typeKey, List<RecoModel>.from(list))),
            );
          });
          final sourceKey = (extKey.isNotEmpty) ? extKey : "unknown-source";
          updatedMap[sourceKey] ??= {
            'default': <RecoModel>[],
            'search': <RecoModel>[],
          };
          if (updatedMap[sourceKey]!['default']!.isEmpty) {
            updatedMap[sourceKey]!['default'] = parsedList;
            updatedMap[sourceKey]!['search'] = isSearch ? parsedList : <RecoModel>[];
          } else if (isSearch) {
            updatedMap[sourceKey]!['search'] = parsedList;
          }
          updatedMap.removeWhere((key, _) => key.trim().isEmpty);
          localProperties.searchManga.value = updatedMap;
          final prefs = await SharedPreferences.getInstance();
          final jsonMap = updatedMap.map((source, typeMap) {
            return MapEntry(
              source,
              typeMap.map((typeKey, list) => MapEntry(typeKey, list.map((e) => e.toJson()).toList())),
            );
          });
          await prefs.setString('searchManga', json.encode(jsonMap));
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