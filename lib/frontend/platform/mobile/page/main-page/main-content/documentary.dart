import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/frontend/platform/mobile/widget/button/icon_card.dart';
import 'package:odem/frontend/platform/mobile/widget/design/fade.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';

import '../../../widget/design/category_compo.dart';
import '../../../widget/button/chapter_card.dart';

class Documentary extends StatefulWidget {

  final RecoModel? extracted;
  const Documentary({
    super.key,
    this.extracted,
  });

  @override
  State<Documentary> createState() => _DocumentaryState();
}

class _DocumentaryState extends State<Documentary> {
  late ScrollController _scrollController;
  bool isFavorite = false;
  bool _isScrolled = false;
  bool isAscending = true;
  bool showMainImage = false;
  bool showBlurredImage = false;


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      bool newShowMainImage = offset >= 250;
      bool newShowBlurredImage = offset >= 100;

      if (newShowMainImage != showMainImage || newShowBlurredImage != showBlurredImage) {
        setState(() {
          showMainImage = newShowMainImage;
          showBlurredImage = newShowBlurredImage;
          _isScrolled = offset > 10; 
        });
      }
    });
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
    
    final main_image = getWeservUrl(widget.extracted!.main_image);
    final cover_image = getWeservUrl(widget.extracted!.cover_image);

    final chapters = isAscending
      ? List.of(widget.extracted!.chapterdetails)
      : List.of(widget.extracted!.chapterdetails.reversed);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            flexibleSpace: ClipRect( 
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedOpacity(
                    opacity: showBlurredImage ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Image.network(
                        cover_image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  AnimatedOpacity(
                    opacity: showBlurredImage ? 0.4 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      color: Colors.black,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),

                  AnimatedOpacity(
                    opacity: (showMainImage && !showBlurredImage) ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: Image.network(
                      main_image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent, 
            title: Transform.translate(
              offset: Offset(-20, 0),
              child: ClipRect( 
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSlide(
                      offset: showMainImage ? Offset(0, 0) : Offset(0, 2),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: 20,
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.network(main_image),
                        ),
                      ),
                    ),
                    Flexible( 
                      child: AnimatedSlide(
                        offset: showMainImage ? Offset(0, 0) : Offset(-0.12, 0),
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 8,
                                  width: 8,
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: widget.extracted!.status == "ongoing"
                                      ? Colors.white30
                                      : Colors.lightGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Flexible(  
                                  child: ContentTitle(title: widget.extracted!.title),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            ContentDescrip(description: widget.extracted!.artists.join(", ")),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 10),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.download_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
              SizedBox(width: 5),
              IconButton(
                icon: const Icon(
                  Icons.widgets_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {},
              ),
              SizedBox(width: 5),
              Builder(
                builder: (context) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                        color: Colors.grey[900],
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: PopupMenuButton<int>(
                      icon: const Icon(
                        Icons.more_vert_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      offset: const Offset(0, 45),
                      onSelected: (int value) {
                        print("Clicked item: $value");
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13
                            ),
                          ),
                        ),
                        // PopupMenuItem<int>(
                        //   value: 2,
                        //   child: Text(
                        //     'Notes',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 13
                        //     ),
                        //   ),
                        // ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text(
                            'Share',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(width: 15),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Transform.translate(
                offset: Offset(0, -60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.white38,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      width: double.infinity,
                                        child: Image.network(
                                        cover_image ?? main_image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'lib/resources/image/static/solo.png',
                                            fit: BoxFit.cover,
                                          );
                                        }
                                      )
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.7), 
                                  ),
                                ],
                              ),
                            )
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Column(
                              children: [
                                CustomPaint(
                                  painter: FadePainter(height: 0.1, begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.1, 
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 25,
                                  color: Colors.black,
                                )
                              ]
                            )
                          ),
                          Container(
                            height: 300,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 170,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: Image.network(
                                            main_image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                'lib/resources/image/static/solo.png',
                                                fit: BoxFit.cover,
                                                color: Colors.black,
                                              );
                                            },
                                          )
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.transparent,
                                          height: 170,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  widget.extracted!.title,
                                                  style: TextStyle(fontSize: 17, color: Colors.white),
                                                ),
                                                ...widget.extracted!.authors
                                                    .take(3)
                                                    .map((author) => Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(right: 2, bottom: 5),
                                                            child: Icon(Icons.person, color: Colors.white, size: 14),
                                                          ),
                                                          ContentDescrip(description: author),
                                                        ],
                                                      )
                                                    )
                                                    .toList(),
                                                if (widget.extracted!.authors.length > 3)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 2),
                                                    child: ContentDescrip(description: "... and other(s)")
                                                  ),
                                              ],
                                            )
                                          ),
                                        ),
                                      )
                                    ]
                                  )
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                              child: IconCard(
                                title: 'Favorite',
                                iconWidget: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) =>
                                      ScaleTransition(scale: animation, child: child),
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    key: ValueKey(isFavorite),
                                    color: isFavorite ? Colors.red : Colors.white70,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconCard(
                              title: widget.extracted!.rating.toString(), 
                              iconData: Icons.timeline
                            )
                          ),
                          Expanded(
                            child: IconCard(
                              title: 'Tracking', 
                              iconData: Icons.hourglass_empty_rounded
                            )
                          ),
                          Expanded(
                            child: IconCard(
                              title: 'WebView', 
                              iconData: Icons.public
                            )
                          )
                        ],
                      )
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15, 
                        vertical: 10
                      ),
                      color: Colors.transparent,
                      width: double.infinity,
                      child: ContentDescrip(description: widget.extracted!.description),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10
                      ),
                      child: CategoryCompo(
                        widget.extracted!.tags
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Chapters',
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isAscending = !isAscending;
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    child: Transform.rotate(
                                      angle: isAscending ? -math.pi / 2 : math.pi / 2,
                                      child: Icon(
                                        Icons.compare_arrows_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            )
                          ),
                          Column(
                            children: List.generate(
                              chapters.length + 1,
                              (index) {
                                if (index == 6) {
                                  if (chapters.length >= 6) {
                                    // final adImageUrl = 'https://images.weserv.nl/?url=' + Uri.encodeComponent('https://www.vistarmedia.com/hubfs/McDonalds%20DOOH%20ad%20billboard-1.jpg');
                                    return SizedBox.shrink();
                                    // Container(
                                    //   height: 40,
                                    //   width: double.infinity,
                                    //   margin: const EdgeInsets.only(bottom: 10),
                                    //   alignment: Alignment.center,
                                    //   child: ClipRect(
                                    //     child: SizedBox.expand(
                                    //       child: Image.network(
                                    //         adImageUrl,
                                    //         fit: BoxFit.cover,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                } else {
                                  // Calculate data index properly
                                  // If index > 6, dataIndex = index - 1 (because of ad)
                                  // If index < 6, dataIndex = index
                                  int dataIndex = index > 6 ? index - 1 : index;

                                  // Protect from out-of-range access:
                                  if (dataIndex < 0 || dataIndex >= chapters.length) {
                                    return SizedBox.shrink();
                                  }

                                  final chapterDetail = chapters[dataIndex];
                                  return ChapterCard(
                                    page: 0,
                                    extracted: chapterDetail,
                                    maindata: widget.extracted!,
                                  );
                                }
                              },
                            ),
                          )

                        ]
                      )
                    )
                  ]
                )
              )
            ]),
          ),
        ],
      ),
    );
  }
}

