import 'dart:convert';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSync {

  static Future<List<RecoModel>> loadRecommendedManga() async {
    final prefs = await SharedPreferences.getInstance();
    final savedManga = prefs.getString('recommended_manga');
    if (savedManga == null || savedManga.isEmpty) return [];

    try {
      final List<dynamic> decodedList = json.decode(savedManga);
      final loadedList = decodedList.map((item) {
        if (item is Map<String, dynamic>) {
          return RecoModel.fromJson(item);
        } else {
          return RecoModel.fromJson(Map<String, dynamic>.from(item));
        }
      }).toList();
      return List<RecoModel>.from(loadedList);
    } catch (e, st) {
      print("Error loading recommended manga from prefs: $e\n$st");
      return [];
    }
  }

  static Future<List<Extension>> loadExtensions() async {
    final prefs = await SharedPreferences.getInstance();
    final savedExtensions = prefs.getString('extensions_data');
    if (savedExtensions == null || savedExtensions.isEmpty) return [];

    try {
      final List<dynamic> decodedList = json.decode(savedExtensions);
      final loadedList = decodedList.map((item) {
        if (item is Map<String, dynamic>) {
          return Extension.fromJson(item);
        } else {
          return Extension.fromJson(Map<String, dynamic>.from(item));
        }
      }).toList();
      return List<Extension>.from(loadedList);
    } catch (e, st) {
      print("Error loading extensions from prefs: $e\n$st");
      return [];
    }
  }

  static Future<List<Extension>> loadInstalledExtension() async {
    final prefs = await SharedPreferences.getInstance();
    final savedInstalled = prefs.getString('installedExtensions');
    if (savedInstalled == null || savedInstalled.isEmpty) return [];

    try {
      final List<dynamic> decodedList = json.decode(savedInstalled);
      final loadedList = decodedList.map((item) {
        if (item is Map<String, dynamic>) {
          return Extension.fromJson(item);
        } else {
          return Extension.fromJson(Map<String, dynamic>.from(item));
        }
      }).toList();
      return List<Extension>.from(loadedList);
    } catch (e, st) {
      print("Error loading installed extensions from prefs: $e\n$st");
      return [];
    }
  }

  static Future<List<Extension>> loadRootExtension() async {
    final prefs = await SharedPreferences.getInstance();

    final savedRoots = prefs.getString('rootExtensions');
    if (savedRoots != null && savedRoots.isNotEmpty) {
      try {
        final List<dynamic> decodedList = json.decode(savedRoots);
        final loadedList = decodedList.map((item) {
          if (item is Map<String, dynamic>) {
            return Extension.fromJson(item);
          } else {
            return Extension.fromJson(Map<String, dynamic>.from(item));
          }
        }).toList();
        return List<Extension>.from(loadedList);
      } catch (e, st) {
        print("Error loading root extensions from prefs: $e\n$st");
      }
    }

    final savedInstalled = prefs.getString('installedExtensions');
    if (savedInstalled == null || savedInstalled.isEmpty) return [];

    try {
      final List<dynamic> decodedList = json.decode(savedInstalled);
      final loadedList = decodedList.map((item) {
        if (item is Map<String, dynamic>) {
          return Extension.fromJson(item);
        } else {
          return Extension.fromJson(Map<String, dynamic>.from(item));
        }
      }).toList();
      return List<Extension>.from(loadedList);
    } catch (e, st) {
      print("Error loading installed extensions as fallback for roots: $e\n$st");
      return [];
    }
  }

  static Future<List<Extension>> loadMigrateExtension() async {
    final prefs = await SharedPreferences.getInstance();

    final savedMigrate = prefs.getString('migrateExtension');
    if (savedMigrate != null && savedMigrate.isNotEmpty) {
      try {
        final List<dynamic> decodedList = json.decode(savedMigrate);
        if (decodedList.isNotEmpty) {
          final loadedList = decodedList.map((item) {
            if (item is Map<String, dynamic>) {
              return Extension.fromJson(item);
            } else {
              return Extension.fromJson(Map<String, dynamic>.from(item));
            }
          }).toList();
          return List<Extension>.from(loadedList);
        } else {
          return await _loadInstalledFallback(prefs);
        }
      } catch (e, st) {
        print("Error loading migrate extensions from prefs: $e\n$st");
        return await _loadInstalledFallback(prefs);
      }
    } else {
      return await _loadInstalledFallback(prefs);
    }
  }

  static Future<List<Extension>> _loadInstalledFallback(SharedPreferences prefs) async {
    final savedInstalled = prefs.getString('installedExtensions');
    if (savedInstalled == null || savedInstalled.isEmpty) return [];

    try {
      final List<dynamic> decodedList = json.decode(savedInstalled);
      final loadedList = decodedList.map((item) {
        if (item is Map<String, dynamic>) {
          return Extension.fromJson(item);
        } else {
          return Extension.fromJson(Map<String, dynamic>.from(item));
        }
      }).toList();
      return List<Extension>.from(loadedList);
    } catch (e, st) {
      print("Error loading installed extensions as fallback for migrate: $e\n$st");
      return [];
    }
  }

  static Future<Map<String, List<RecoModel>>> loadMigrationData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMigrationData = prefs.getString('migrationData');
    if (savedMigrationData == null || savedMigrationData.isEmpty) return {};

    try {
      final Map<String, dynamic> decodedMap = json.decode(savedMigrationData);
      final Map<String, List<RecoModel>> migrationData = decodedMap.map((key, value) {
        final list = (value as List).map((item) => RecoModel.fromJson(item)).toList();
        return MapEntry(key, list);
      });
      return migrationData;
    } catch (e, st) {
      print("Error loading migrationData: $e\n$st");
      return {};
    }
  }

  static Future<Map<String, List<RecoModel>>> loadLibraryData() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString("libraryData");
    if (stored == null || stored.isEmpty) return {};

    try {
      final decoded = jsonDecode(stored) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(
        key,
        (value as List).map((e) => RecoModel.fromJson(e)).toList(),
      ));
    } catch (e, st) {
      print("Error loading libraryData: $e\n$st");
      return {};
    }
  }

  static Future<void> saveLibraryData(Map<String, List<RecoModel>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = data.map((key, value) => MapEntry(
        key,
        value.map((e) => e.toJson()).toList(),
      ));
    await prefs.setString("libraryData", jsonEncode(encoded));
  }

  static Future<Map<String, Map<String, List<RecoModel>>>> loadSavedSearchManga() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('searchManga');
    if (stored == null || stored.isEmpty) return {};

    try {
      final Map<String, dynamic> raw = json.decode(stored);

      final parsed = raw.map((source, lists) {
        final m = (lists as Map<String, dynamic>);
        final def = (m['default'] as List? ?? const [])
            .map((e) => RecoModel.fromJson(e))
            .toList();

        return MapEntry(source, {
          'default': def,
          'search': <RecoModel>[],
        });
      });

      return parsed;
    } catch (e, st) {
      print("Error loading searchManga from prefs: $e\n$st");
      return {};
    }
  }

}
