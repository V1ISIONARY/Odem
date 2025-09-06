import 'package:flutter/widgets.dart';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/functionalities/sync.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/recommend.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalProperties extends ChangeNotifier {
  static final LocalProperties instance = LocalProperties._internal();
  factory LocalProperties() => instance;
  LocalProperties._internal();

  final libraryData = ValueNotifier<Map<String, List<RecoModel>>>({});
  final libraryManga = ValueNotifier<List<RecoModel>>([]);
  final recommendManga = ValueNotifier<List<RecoModel>>([]);
  
  final mangaImg = ValueNotifier<List<MangaImgModel>>([]);
  Map<String, List<MangaImgModel>> mangaImgSections = {
    'previous': [],
    'current': [],
    'next': [],
  };

  final selectedRootIndex = ValueNotifier<int?>(null);
  final mangaRoot = ValueNotifier<String>("");
  final libraryRoot = ValueNotifier<String>("");

  final installedExtension = ValueNotifier<List<Extension>>([]);
  final migrateExtension = ValueNotifier<List<Extension>>([]);
  final rootsExtension = ValueNotifier<List<Extension>>([]);
  final extensions = ValueNotifier<List<Extension>>([]);
  final onSearchPage = ValueNotifier<bool>(false);

  final searchManga = ValueNotifier<Map<String, Map<String, List<RecoModel>>>>({});
  final migrationData = ValueNotifier<Map<String, List<RecoModel>>>({});

  Future<void> syncData() async {
    await _syncIfEmpty(installedExtension, DataSync.loadInstalledExtension, post: (list) {
      migrateExtension.value = [...list];
      rootsExtension.value = [...list];
    });
    await _syncIfEmpty(migrateExtension, () async => installedExtension.value);
    await _syncIfEmpty(rootsExtension, () async => installedExtension.value);
    await _syncIfEmpty(recommendManga, DataSync.loadRecommendedManga);
    await _syncIfEmpty(migrationData, DataSync.loadMigrationData);
    await _syncIfEmpty(extensions, DataSync.loadExtensions);
    await _syncIfEmpty(searchManga, DataSync.loadSavedSearchManga);
    await _syncIfEmpty(libraryData, DataSync.loadLibraryData);
    await loadSavedMangaRoot();
    notifyListeners();
  }

  Future<void> _syncIfEmpty<T>(
    ValueNotifier<T> target,
    Future<T> Function() loader, {
    void Function(T value)? post,
  }) async {
    if ((target.value is List && (target.value as List).isEmpty) ||
        (target.value is Map && (target.value as Map).isEmpty)) {
      final loaded = await loader();
      target.value = loaded;
      post?.call(loaded);
    }
  }

  Future<void> loadSavedMangaRoot() async {
    final prefs = await SharedPreferences.getInstance();
    final savedKey = prefs.getString('mangaRoot') ?? '';
    if (savedKey.isEmpty) return;

    for (var i = 0; i < 20 && rootsExtension.value.isEmpty; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final idx = rootsExtension.value.indexWhere(
      (e) => e.key.trim().toLowerCase() == savedKey.trim().toLowerCase(),
    );
    if (idx != -1) {
      await _setMangaRoot(savedKey, idx);
    }
  }

  Future<void> setMangaRootByIndex(int idx) async {
    if (idx >= 0 && idx < rootsExtension.value.length) {
      await _setMangaRoot(rootsExtension.value[idx].key, idx);
    }
  }

  Future<void> _setMangaRoot(String key, int idx) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mangaRoot', key);
    mangaRoot.value = key;
    selectedRootIndex.value = idx;

    final foundKey = migrationData.value.keys.firstWhere(
      (k) => k.trim().toLowerCase() == key.trim().toLowerCase(),
      orElse: () => '',
    );
    if (foundKey.isNotEmpty) {
      final list = migrationData.value[foundKey];
      if (list != null && list.isNotEmpty) recommendManga.value = List.from(list)..shuffle();
    }
    notifyListeners();
  }
  
  final ValueNotifier<bool> longPressedIndex = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showSearchPage = ValueNotifier<bool>(false);
  
  final GlobalKey<SearchState> searchScroll = GlobalKey();
  final GlobalKey<SearchState> libraryScroll = GlobalKey();
  final GlobalKey<RecommendState> recommendScroll = GlobalKey();

  Future<void> restartScrolls() async {
    searchScroll.currentState?.scrollToTop();
    libraryScroll.currentState?.scrollToTop();
    recommendScroll.currentState?.scrollToTop();
  }

  String getWeservUrl(String originalUrl) {
    if (originalUrl.contains("proxy_image?url=")) {
      return originalUrl;
    }

    // Otherwise, convert the direct CDN URL for Weserv
    final noProtocol = originalUrl.replaceFirst(RegExp(r'^https?://'), '');
    final parts = noProtocol.split('/');
    final domain = parts.first;
    final pathSegments = parts.sublist(1).map(Uri.encodeComponent).join('/');

    return 'https://images.weserv.nl/?url=$domain/$pathSegments';
  }

}