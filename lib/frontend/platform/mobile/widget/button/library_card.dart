import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/functionalities/sync.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/documentary.dart';
import 'package:page_transition/page_transition.dart';
import '../schema/text_format.dart';

class LibraryCard extends StatefulWidget {
  final RecoModel? zipdata;
  final bool disableTap;
  final bool isExpanded;
  final VoidCallback onLongPress;
  final bool showCircle;
  final VoidCallback unFav;

  const LibraryCard({
    super.key,
    this.zipdata,
    required this.disableTap,
    required this.isExpanded,
    required this.onLongPress,
    this.showCircle = true,
    required this.unFav,
  });

  @override
  State<LibraryCard> createState() => _LibraryCardState();
}

class _LibraryCardState extends State<LibraryCard> {
  final localProperties = LocalProperties();
  bool isFav = true; 

  String? _getLogoUrl(String sourceKey) {
    final extensions = localProperties.installedExtension.value;

    try {
      final match = extensions.firstWhere(
        (ext) => ext.key == sourceKey,
      );
      return localProperties.getWeservUrl(match.logoImg);
    } catch (e) {
      return null; 
    }
  }

  @override
  Widget build(BuildContext context) {
    final main_image = localProperties.getWeservUrl(widget.zipdata!.main_image);
    if (widget.zipdata == null) return const SizedBox();

    return GestureDetector(
      onTap: widget.disableTap
        ? null
        : () {
          if (widget.zipdata?.chapterdetails.isNotEmpty ?? false) {
            localProperties.libraryRoot.value = widget.zipdata!.chapterdetails.first.sourceKey;
            Navigator.push(
              context,
              PageTransition(
                child: Documentary(extracted: widget.zipdata),
                duration: const Duration(milliseconds: 300),
                type: PageTransitionType.rightToLeft,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No chapter details available")),
            );
          }
        },
      onLongPress: () {
        setState(() {
          isFav = true; 
        });
        widget.onLongPress(); 
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        height: widget.isExpanded ? 250 : 180,
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
                      if (widget.showCircle)
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(
                                width: 2, 
                                color: Colors.white
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 1, 
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Builder(
                                builder: (_) {
                                  final sourceKey = widget.zipdata!.chapterdetails.first.sourceKey;
                                  final logoUrl = _getLogoUrl(sourceKey);

                                  if (logoUrl != null && logoUrl.isNotEmpty) {
                                    return Image.network(
                                      logoUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'lib/resources/image/static/solo.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    );
                                  } else {
                                    return Image.asset(
                                      'lib/resources/image/static/solo.png',
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
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
                horizontal: widget.isExpanded ? 5 : 0, 
                vertical: 2
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.zipdata!.isPinned
                        ? Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Transform.rotate(
                            angle: -3.14 / 2,
                            child: const Icon(
                              Icons.push_pin,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        )
                       : SizedBox.shrink(),
                      Flexible(
                        child: ContentTitle(title: widget.zipdata!.title)
                      ),
                    ]
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ContentDescrip(
                        description:
                        'CH: ${widget.zipdata!.chapter_count} - V: ${widget.zipdata!.volume_count}',
                      ),
                      const Spacer(),
                      ContentDescrip(
                        description: "${widget.zipdata!.rating.toString()}R",
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
                child: isFav
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              widget.zipdata!.isPinned = !widget.zipdata!.isPinned;
                            });
                            final key = widget.zipdata!.chapterdetails.first.sourceKey;
                            final current = localProperties.libraryData.value;

                            if (current.containsKey(key)) {
                              current[key] = current[key]!
                                .map<RecoModel>((m) {
                                  if (m.mangaid == widget.zipdata!.mangaid) {
                                    return RecoModel(
                                      tags: m.tags,
                                      artists: m.artists,
                                      authors: m.authors,
                                      updatedAt: m.updatedAt,
                                      isFavorite: widget.zipdata!.isFavorite,
                                      isPinned: widget.zipdata!.isPinned, 
                                      chapterdetails: m.chapterdetails,
                                      chapter_count: m.chapter_count,
                                      volume_count: m.volume_count,
                                      description: m.description, 
                                      cover_image: m.cover_image, 
                                      main_image: m.main_image,
                                      mangaid: m.mangaid,
                                      rating: m.rating,
                                      status: m.status, 
                                      title: m.title,
                                    );
                                  }
                                  return m;
                                })
                                .toList();
                            }

                            localProperties.libraryData.value = Map.from(current);
                            localProperties.libraryManga.value = localProperties.libraryManga.value; // refresh UI
                            await DataSync.saveLibraryData(localProperties.libraryData.value);

                            widget.onLongPress();
                          },
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                    width: 0.5, color: Colors.white38),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  widget.zipdata!.isPinned ? 'Unpin' : 'Pin',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                const Spacer(),
                                Icon(
                                  widget.zipdata!.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                  color: Colors.white,
                                  size: 13,
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFav = !isFav;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(color: Colors.transparent),
                            child: Row(
                              children: [
                                Text(
                                  isFav ? 'Unfavorite' : 'Favorite',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                                const Spacer(),
                                Icon(
                                  isFav
                                    ? Icons.favorite_outlined
                                    : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 13,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFav = !isFav;
                          });
                          widget.unFav();
                          widget.onLongPress();
                        },
                        child: Container(
                          height: 30,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            border: Border(
                              bottom: BorderSide(
                                width: 0.5, 
                                color: Colors.red
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)
                            )
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Yes',
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10
                                ),
                              ),
                            ]
                          )
                        )
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isFav = !isFav;
                          });
                        },
                        child: Container(
                          height: 30,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(color: Colors.transparent),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'No',
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10
                                ),
                              ),
                            ]
                          )
                        )
                      ),
                    ],
                  ) 
              ),
              duration: const Duration(milliseconds: 400),
              crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}