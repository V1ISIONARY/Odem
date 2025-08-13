import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/documentary.dart';
import 'package:page_transition/page_transition.dart';
import '../schema/text_format.dart';

class SingleCard extends StatefulWidget {
  final RecoModel? zipdata;
  const SingleCard({
    super.key,
    this.zipdata,
  });

  @override
  State<SingleCard> createState() => _SingleCardState();
}

  String getWeservUrl(String originalUrl) {
    final noProtocol = originalUrl.replaceFirst(RegExp(r'^https?://'), '');
    final parts = noProtocol.split('/'); 
    final domain = parts.first;
    final pathSegments = parts.sublist(1).map(Uri.encodeComponent).join('/');
    return 'https://images.weserv.nl/?url=$domain/$pathSegments';
  }

class _SingleCardState extends State<SingleCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.zipdata == null) {
      return const SizedBox();
    }

    final main_image = getWeservUrl(widget.zipdata!.main_image);

    return GestureDetector(
      onTap: () {
        if (widget.zipdata?.chapterdetails.isNotEmpty ?? false) {
          Navigator.push(
            context,
            PageTransition(
              child: Documentary(extracted: widget.zipdata),
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
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: main_image.isNotEmpty
                    ? Image.network(
                        main_image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Image.asset(
                            'lib/resources/image/static/solo.png',
                            fit: BoxFit.cover,
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Image failed to load: $error');
                          return Image.network(
                            'https://images.comico.io/meta/og_thmb_pocket.jpeg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'lib/resources/image/static/solo.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              height: 45,
              padding: const EdgeInsets.only(top: 10),
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ContentTitle(title: widget.zipdata!.title),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ContentDescrip(
                        description:
                            'CH: ${widget.zipdata!.chapter_count} - V: ${widget.zipdata!.volume_count}',
                      ),
                      const Spacer(),
                      ContentDescrip(
                        description: "${widget.zipdata!.rating.toString()}R",
                        color: Colors.blue,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}