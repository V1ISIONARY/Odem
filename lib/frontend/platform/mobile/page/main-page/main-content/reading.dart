import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/design/category_compo.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/color.dart';
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
  int _loadedImagesCount = 0;
  bool _isScrolled = false;

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

  void _updateCurrentPageProgress() {
    if (_visibleFractions.isEmpty) return;
    final imagesCount = localProperties.mangaImg.value.length;
    double progressSum = 0;
    double fractionSum = 0;
    _visibleFractions.forEach((index, visibleFraction) {
      progressSum += (index + 1) * visibleFraction;
      fractionSum += visibleFraction;
    });
    if (fractionSum == 0) return;
    final progress = progressSum / fractionSum;
    if ((progress - _currentPageProgress).abs() > 0.01) {
      setState(() {
        _currentPageProgress = progress.clamp(1, imagesCount).toDouble();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String getWeservUrl(String originalUrl) {
    final noProtocol = originalUrl.replaceFirst(RegExp(r'^https?://'), '');
    final parts = noProtocol.split('/'); 
    final domain = parts.first;
    final pathSegments = parts.sublist(1).map(Uri.encodeComponent).join('/');
    return 'https://images.weserv.nl/?url=$domain/$pathSegments';
  }

  @override
  Widget build(BuildContext context) {
    bool isSpecialChapter = widget.extracted!.chapter.trim().contains(":");
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<List<MangaImgModel>>(
        valueListenable: localProperties.mangaImg,
        builder: (context, images, _) {
          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final mainImage = getWeservUrl(images[index].url.trim());
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
                                    _loadedImagesCount++;
                                    if (!_imagesLoaded && _loadedImagesCount == images.length) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          _imagesLoaded = true;
                                          Future.delayed(const Duration(seconds: 10), () {
                                            if (mounted) { 
                                              setState(() {
                                                _showFullScreenLoader = false;
                                                _hasShownLoader = true;
                                              });
                                            }
                                          });
                                       });
                                      });
                                    }
                                    return child;
                                  }
                                  return child;
                                },
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: images.length,
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
                      child: Center(
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  localProperties.mangaImg.value = [];
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