import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/button/single_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recommend extends StatefulWidget {
  
  final String userToken;
  const Recommend({
    super.key, 
    required this.userToken
  });

  @override
  State<Recommend> createState() => RecommendState();
}

class RecommendState extends State<Recommend> {
  final localProperties = LocalProperties();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _cardKeys = {};
  int? _longPressedIndex;

  Offset? _selectedCardPosition;
  Size? _selectedCardSize;
  bool _isCentered = false;

  void _onLongPress(int index) {
    final key = _cardKeys[index];
    if (key == null) return;
    final context = key.currentContext;
    if (context == null) return;
    final box = context.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final size = box.size;

    setState(() {
      _longPressedIndex = index;
      _selectedCardPosition = position;
      _selectedCardSize = size;
      _isCentered = false;
    });

    localProperties.longPressedIndex.value = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isCentered = true);
    });
  }

  void scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    localProperties.longPressedIndex.addListener(() {
      if (!localProperties.longPressedIndex.value) {
        _onLongPressEnd();
      }
    });
  }


  void _onLongPressEnd() async {
    if (_longPressedIndex == null) return;

    setState(() {
      _isCentered = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _longPressedIndex = null;
      _selectedCardPosition = null;
      _selectedCardSize = null;
    });
  }

  Future<void> endLongPress() async {
    _onLongPressEnd();
  }

  @override
  Widget build(BuildContext context) {
    final recommendList = localProperties.recommendManga.value;
    if (recommendList.isEmpty) return _emptyState();

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            int crossAxisCount = (screenWidth / 150).floor();
            if (crossAxisCount < 1) crossAxisCount = 1;

            final filteredItems = recommendList.where((item) {
              return item.chapter_count != "0" && item.chapterdetails.isNotEmpty;
            }).toList();

            int itemCount = filteredItems.length;
            if (itemCount % crossAxisCount == 1) {
              itemCount -= 1;
            }
            return GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 100 / 200,
              ),
              itemCount: itemCount,
              physics: _longPressedIndex != null
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final manga = filteredItems[index];
                final isSelected = _longPressedIndex == index;
                _cardKeys.putIfAbsent(index, () => GlobalKey());

                return Opacity(
                  opacity: isSelected ? 0.0 : 1.0,
                  child: GestureDetector(
                    key: _cardKeys[index],
                    onLongPress: () => _onLongPress(index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SingleCard(
                        zipdata: manga,
                        disableTap: false,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),

        if (_longPressedIndex != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: _onLongPressEnd,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),

        if (_longPressedIndex != null &&
            _selectedCardPosition != null &&
            _selectedCardSize != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _isCentered
              ? MediaQuery.of(context).size.height / 2 - (_selectedCardSize!.height + 100) / 2 - 100
              : _selectedCardPosition!.dy - 50,
            left: _isCentered
              ? MediaQuery.of(context).size.width / 2 - _selectedCardSize!.width / 2
              : _selectedCardPosition!.dx,
            width: _selectedCardSize!.width,
            height: _selectedCardSize!.height + 100,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 1.0,
                end: (_longPressedIndex != null && _isCentered) ? 1.3 : 1.0,
              ),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: _selectedCardSize!.height,
                      width: _selectedCardSize!.width,
                      child: SingleCard(
                        zipdata: recommendList[_longPressedIndex!],
                        disableTap: true,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, 270),
                      child: Container(
                        height: 94,
                        width: _selectedCardSize!.width + 15,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 45, 45, 45),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final localProperties = LocalProperties();
                                final manga = recommendList[_longPressedIndex!];
                                final sourceKey = manga.chapterdetails.first.sourceKey;

                                final currentMap = Map<String, List<RecoModel>>.from(localProperties.libraryData.value);

                                if (!currentMap.containsKey(sourceKey)) {
                                  currentMap[sourceKey] = [];
                                }

                                final isFavorite = currentMap[sourceKey]!
                                    .any((item) => item.mangaid == manga.mangaid);

                                if (isFavorite) {
                                  currentMap[sourceKey]!.removeWhere((item) => item.mangaid == manga.mangaid);
                                } else {
                                  currentMap[sourceKey]!.insert(0, manga);
                                }

                                localProperties.libraryData.value = currentMap;
                                final prefs = await SharedPreferences.getInstance();
                                final serializedMap = currentMap.map(
                                  (key, list) => MapEntry(key, list.map((m) => m.toJson()).toList()),
                                );
                                await prefs.setString("libraryData", jsonEncode(serializedMap));

                                setState(() {}); 
                                _onLongPressEnd();
                              },
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: const Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final localProperties = LocalProperties();
                                        final sourceKey = recommendList[_longPressedIndex!].chapterdetails.first.sourceKey;

                                        final isFavorite = localProperties.libraryData.value[sourceKey]
                                          ?.any((item) => item.mangaid == recommendList[_longPressedIndex!].mangaid) ??
                                          false;

                                        return Text(
                                          isFavorite ? 'Unfavorite' : 'Favorite',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        );
                                      }
                                    ),
                                    Spacer(),
                                    Builder(
                                      builder: (context) {
                                        final localProperties = LocalProperties();
                                        final sourceKey = recommendList[_longPressedIndex!].chapterdetails.first.sourceKey;

                                        final isFavorite = localProperties.libraryData.value[sourceKey]
                                          ?.any((item) => item.mangaid == recommendList[_longPressedIndex!].mangaid) ??
                                          false;

                                        return AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 300),
                                          transitionBuilder: (child, animation) => ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          ),
                                          child: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            key: ValueKey(isFavorite),
                                            color: isFavorite ? Colors.red : Colors.white,
                                            size: 13,
                                          ),
                                        );
                                      }
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: const Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Download',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.downloading_sharp,
                                      color: Colors.white,
                                      size: 13,
                                    )
                                  ],
                                )
                              )
                            ),
                            GestureDetector(
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.ios_share_rounded,
                                      color: Colors.white,
                                      size: 13,
                                    )
                                  ],
                                )
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 80,
          //   width: 80,
          //   child: ColoredBox(color: Colors.white10),
          // ),
          // SizedBox(height: 10),
          Text(
            'Empty Data',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          SizedBox(height: 5),
          Text(
            "you're required to install extension or migrate\nyour extension",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}