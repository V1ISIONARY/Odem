import 'package:flutter/material.dart';
import 'package:odem/backend/model/extension.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/documentary.dart';
import 'package:page_transition/page_transition.dart';
import '../schema/text_format.dart';

class LibraryCard extends StatelessWidget {
  final RecoModel? zipdata;
  final bool disableTap;
  final bool isExpanded;
  final VoidCallback onLongPress;
  final bool showCircle;

  const LibraryCard({
    super.key,
    this.zipdata,
    required this.disableTap,
    required this.isExpanded,
    required this.onLongPress,
    this.showCircle = true,
  });

  String getWeservUrl(String originalUrl) {
    final noProtocol = originalUrl.replaceFirst(RegExp(r'^https?://'), '');
    final parts = noProtocol.split('/');
    final domain = parts.first;
    final pathSegments = parts.sublist(1).map(Uri.encodeComponent).join('/');
    return 'https://images.weserv.nl/?url=$domain/$pathSegments';
  }

  @override
  Widget build(BuildContext context) {
    if (zipdata == null) return const SizedBox();

    final main_image = getWeservUrl(zipdata!.main_image);

    return GestureDetector(
      onTap: disableTap
          ? null
          : () {
              if (zipdata?.chapterdetails.isNotEmpty ?? false) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: Documentary(extracted: zipdata),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No chapter details available")),
                );
              }
            },
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        height: isExpanded ? 250 : 180,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: main_image.isNotEmpty
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              main_image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'lib/resources/image/static/solo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (showCircle)
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      )
                    : Image.asset(
                        'lib/resources/image/static/solo.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              height: 45,
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 5 : 0, 
                vertical: 2
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: ContentTitle(title: zipdata!.title)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ContentDescrip(
                        description: 'CH: ${zipdata!.chapter_count} - V: ${zipdata!.volume_count}',
                      ),
                      const Spacer(),
                      ContentDescrip(
                        description: "${zipdata!.rating.toString()}R",
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 45, 45, 45),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(children: [
                  Container(
                    height: 30,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.white38),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          'Pin',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 10
                          )
                        ),
                        Spacer(),
                        Icon(
                          Icons.push_pin_outlined,
                          color: Colors.white, 
                          size: 13
                        )
                      ],
                    )
                  ),
                  Container(
                    height: 30,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Row(
                      children: const [
                        Text('Unfavorite',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 10
                          )
                        ),
                        Spacer(),
                        Icon(
                          Icons.favorite_outlined,
                          color: Colors.white, 
                          size: 13
                        )
                      ],
                    )
                  ),
                ]),
              ),
              duration: const Duration(milliseconds: 400),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}