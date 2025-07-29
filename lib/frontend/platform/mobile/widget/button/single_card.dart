import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/reco.dart';
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

class _SingleCardState extends State<SingleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageTransition(
            child: Documentary(
              extracted: widget.zipdata
            ),
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
                child: widget.zipdata!.cover_image.isNotEmpty
                ? Image.network(
                    widget.zipdata!.cover_image,
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
                        description: 'CH: ${widget.zipdata!.chapter_count} - V: ${widget.zipdata!.volume_count}'
                      ),
                      Spacer(),
                      ContentDescrip(
                        description: "${widget.zipdata!.rating.toString()}R",
                        color: Colors.blue
                      )
                    ],
                  )
                ],
              )
            )
          ]
        )
      )
    );
  }
}