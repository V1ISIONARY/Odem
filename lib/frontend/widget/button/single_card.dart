import 'package:flutter/material.dart';
import 'package:odem/frontend/page/main-page/main-content/documentary.dart';
import 'package:page_transition/page_transition.dart';

import '../schema/text_format.dart';

class SingleCard extends StatefulWidget {

  final int mangaId;
  final String title;
  final String ratings;
  final String thumbnail;
  final String description;
  const SingleCard({
    super.key,
    required this.title,
    required this.ratings,
    required this.mangaId,
    required this.thumbnail,
    required this.description
  });

  @override
  State<SingleCard> createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageTransition(
            child: Documentary(mangaId: 1),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 300),
          ),
        );
      },
      onLongPress: (){},
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: widget.thumbnail.isNotEmpty
                ? Image.network(
                    widget.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'lib/resources/image/static/solo.png',
                        fit: BoxFit.cover,
                        color: Colors.white,
                      );
                    },
                  )
                : Image.asset(
                    'lib/resources/image/static/solo.png',
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
              )
            ),
            Container(
              height: 45,
              padding: EdgeInsets.only(
                top: 10
              ),
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContentTitle(title: widget.title),
                        ContentDescrip(description: widget.description)
                      ],
                    )
                  ),
                  Positioned(
                    right: 0,
                    bottom: 10,
                    child: ContentDescrip(description: widget.ratings)
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }
}