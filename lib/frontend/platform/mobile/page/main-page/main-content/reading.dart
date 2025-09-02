import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/functionalities/sync.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Reading extends StatefulWidget {
  final ChapterDetail? extracted;
  final RecoModel? maindata;

  const Reading({
    super.key,
    required this.extracted,
    required this.maindata,
  });

  @override
  State<Reading> createState() => _ReadingState();
}

class _ReadingState extends State<Reading> {
  final localProperties = LocalProperties();
  late ScrollController _scrollController;
  Map<int, double> _visibleFractions = {};
  bool _showFullScreenLoader = true;
  double _currentPageProgress = 0;
  bool _hasShownLoader = false;
  bool _imagesLoaded = false;
  final Set<int> _loadedImageIndexes = {};
  bool _isScrolled = false;
  bool _canSaved = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 100;
      if (scrolled != _isScrolled) {
        setState(() {
          _isScrolled = scrolled;
        });
      }
    });
  }

  void scrollToPage({int? pageIndex}) {
    if (!_scrollController.hasClients) return;

    final imagesCount = localProperties.mangaImg.value.length;
    if (imagesCount == 0) return;

    final targetPage = pageIndex ??
        ((_currentPageProgress / 100 * imagesCount).clamp(0, imagesCount - 1)).toInt();

    double itemHeight = 300;
    final targetOffset = targetPage * itemHeight;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _markChapterAsRead() async {
    final currentChapter = widget.extracted;
    if (currentChapter == null) return;
    final chapters = widget.maindata?.chapterdetails;
    if (chapters == null) return;
    final index = chapters.indexWhere((c) => c.chapter == currentChapter.chapter);
    if (index != -1) {
      setState(() {
        chapters[index].percentage = 100;
        chapters[index].timeRead = DateTime.now();
      });
      await DataSync.saveLibraryData(localProperties.libraryData.value);
      await localProperties.syncData();
      debugPrint("✅ Chapter ${currentChapter.chapter} marked as 100% read & saved");
    }
  }

  void _updateCurrentPageProgress() async {
    if (_visibleFractions.isEmpty) return;
    final imagesCount = localProperties.mangaImg.value.length;
    if (imagesCount == 0) return;

    int lastVisibleIndex = _visibleFractions.entries
      .where((e) => e.value > 0.1)
      .map((e) => e.key)
      .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);

    int progress = lastVisibleIndex + 1;

    if (lastVisibleIndex == imagesCount - 1) {
      progress = imagesCount;
    }

    if (!mounted || progress == _currentPageProgress) return;

    setState(() {
      _currentPageProgress = progress.toDouble();

      final currentChapter = widget.extracted;
      final chapters = widget.maindata?.chapterdetails;
      if (currentChapter == null || chapters == null) return;

      final index = chapters.indexWhere((c) => c.chapter == currentChapter.chapter);
      if (index == -1) return;

      final percent = ((_currentPageProgress / imagesCount) * 100).clamp(0, 100).toInt();

      if (_canSaved == true) {
        if (percent == 100) {
          chapters[index].percentage = percent;
          if (imagesCount > 1 && lastVisibleIndex == imagesCount - 1) {
            if (_currentPageProgress >= imagesCount) {
              _markChapterAsRead();
            };
          }
        } 
      }
      
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSpecialChapter = widget.extracted!.chapter.trim().contains(":");
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<List<MangaImgModel>>(
        valueListenable: localProperties.mangaImg,
        builder: (context, images, _) {
          if (images.isNotEmpty && !_imagesLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {
                _imagesLoaded = false;
                _showFullScreenLoader = true;
                _hasShownLoader = false;
                _canSaved = false;
              });

              Future.delayed(const Duration(seconds: 5), () {
                if (!mounted) return;
                setState(() {
                  _imagesLoaded = true;          
                  _showFullScreenLoader = false;
                  _hasShownLoader = true;
                });
              });
            });
          }
          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == images.length) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(left: 20),
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle_sharp, color: Colors.white, size: 15),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Current Chapter: ${widget.extracted!.chapter}",
                                      style: const TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.circle_outlined, color: Colors.white, size: 15),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Next Chapter: ${widget.extracted!.chapter}",
                                      style: const TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } 

                        if (index < images.length) {
                          final mainImage = localProperties.getWeservUrl(images[index].url.trim());
                          return VisibilityDetector(
                            key: Key('image_visibility_$index'),
                            onVisibilityChanged: (visibilityInfo) {
                              _visibleFractions[index] = visibilityInfo.visibleFraction;
                              _updateCurrentPageProgress();
                            },
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() => _showFullScreenLoader = !_showFullScreenLoader);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Image.network(
                                  mainImage,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      if (!_loadedImageIndexes.contains(index)) {
                                        _loadedImageIndexes.add(index);
                                        if (!_imagesLoaded &&
                                            _loadedImageIndexes.length == images.length) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (!mounted) return;
                                            setState(() {
                                              _imagesLoaded = false;
                                              _showFullScreenLoader = true;
                                              _hasShownLoader = false;
                                              _canSaved = false;
                                              Future.delayed(const Duration(seconds: 5), () {
                                                _imagesLoaded = true;
                                                _showFullScreenLoader = false;
                                                _hasShownLoader = true;
                                                _canSaved = true;
                                                // if (widget.extracted!.percentage != 100) {
                                                //   scrollToPage(pageIndex: localProperties.mangaImg.value.length - 1);
                                                // } else {
                                                //   scrollToPage(
                                                //     pageIndex: widget.extracted!.percentage
                                                //   );
                                                // }
                                              });
                                            });
                                          });
                                        }
                                      }
                                      return child;
                                    }
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      childCount: images.length + 1,
                    ),
                  ),
                ],
              ),

              if (_showFullScreenLoader && !_hasShownLoader)
                Positioned.fill(
                  child: Container(
                    color: Colors.black12,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: _showFullScreenLoader ? Offset(0, 0) : Offset(0, 1),
                  curve: Curves.easeInOut,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30, right: 30, left: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, 
                            vertical: 8
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  localProperties.mangaImg.value = [];
                                  localProperties.libraryRoot.value = "";
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ContentTitle(
                                            title: isSpecialChapter
                                              ? "${widget.maindata!.title}"
                                                "${_hasShownLoader ? "  •  Page ${_currentPageProgress.toStringAsFixed(0)}/${images.length} "
                                                  "(${((_currentPageProgress / images.length) * 100).toStringAsFixed(0)}%)" : ""}"
                                              : widget.maindata!.title,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ContentDescrip(
                                      description: isSpecialChapter
                                        ? widget.extracted!.chapter
                                        : "${widget.extracted!.chapter}"
                                          "${_hasShownLoader ? " - Page ${_currentPageProgress.toStringAsFixed(0)} of ${images.length} "
                                            "(${((_currentPageProgress / images.length) * 100).toStringAsFixed(0)}%)" : ""}",
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.download_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.more_vert_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}