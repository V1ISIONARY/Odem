import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:odem/frontend/widget/button/icon_card.dart';
import 'package:odem/frontend/widget/design/fade.dart';
import 'package:odem/frontend/widget/schema/color.dart';
import 'package:odem/frontend/widget/schema/text_format.dart';

import '../../../widget/design/category_compo.dart';
import '../../../widget/button/chapter_card.dart';

class Documentary extends StatefulWidget {
  final int mangaId;
  const Documentary({
    super.key,
    required this.mangaId,
  });

  @override
  State<Documentary> createState() => _DocumentaryState();
}

class _DocumentaryState extends State<Documentary> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 10 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            elevation: 4,
            flexibleSpace: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _isScrolled ? 1.0 : 0.0, 
              child: Container(
                color: primary_color,
              ),
            ),
            backgroundColor: Colors.transparent, 
            title: Transform.translate(
              offset: Offset(-20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContentTitle(title: 'Solo Leveling'),
                  ContentDescrip(description: 'Chingchong (negah)')
                ],
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
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 10),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Icon(Icons.download_outlined, color: Colors.white, size: 20)
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Icon(Icons.widgets_outlined, color: Colors.white, size: 20)
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Icon(Icons.more_vert_outlined, color: Colors.white, size: 20)
                      ),
                    )
                  ]
                ),
              )
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
                                  Container(
                                    width: double.infinity,
                                      child: Image.network(
                                      'lib/resources/image/static/solo.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'lib/resources/image/static/solo.png',
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    )
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
                                            'lib/resources/image/static/solo.png',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                'lib/resources/image/static/solo.png',
                                                fit: BoxFit.cover,
                                                color: Colors.white,
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
                                                  'Solo Leveling',
                                                  style: TextStyle(fontSize: 17, color: Colors.white),
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 2, bottom: 5),
                                                      child: Icon(Icons.person, color: Colors.white, size: 14),
                                                    ),
                                                    ContentDescrip(description: 'Chingchong (Negah)')
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 2, bottom: 5),
                                                      child: Icon(Icons.person, color: Colors.white, size: 14),
                                                    ),
                                                    ContentDescrip(description: 'Chingchong (Negah)')
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 2),
                                                      child: Icon(Icons.person, color: Colors.white, size: 14),
                                                    ),
                                                    ContentDescrip(description: 'Chingchong (Negah)')
                                                  ],
                                                )
                                              ],
                                            ),
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
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: IconCard(
                              title: 'Favorite', 
                              iconData: Icons.monitor_heart_sharp
                            )
                          ),
                          Expanded(
                            child: IconCard(
                              title: 'N/A', 
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
                      child: ContentDescrip(description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10
                      ),
                      child: CategoryCompo(),
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
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center, 
                                    child: Icon(
                                      Icons.widgets_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  )
                                )
                              ]
                            )
                          ),
                          ChapterCard(
                            chapter: 1, 
                            page: 3, 
                            date: '9/22/2024', 
                            status: Icons.check
                          ),
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

