import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/model/manga/chapter_detail.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/reading.dart';
import 'package:page_transition/page_transition.dart';

import '../schema/text_format.dart';

class ChapterCard extends StatelessWidget {
  
  final int? page;
  final IconData? status;
  final ChapterDetail extracted;
  final RecoModel maindata;
  const ChapterCard({
    super.key,
    required this.extracted,
    required this.maindata,
    this.status,
    this.page
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.read<MangaBloc>().add(FetchMangaImages(extracted.link));
        Navigator.push(
          context,
          PageTransition(
            child: Reading(
              extracted: extracted,
              maindata: maindata,
            ),
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentTitle(title: '${extracted.chapter}'),
                ContentDescrip(
                  description: page != null && page! > 0 
                    ? '${extracted.date} ⋅ Page: $page' 
                    : extracted.date,
                  size: 9,
                ),
              ],
            ),
            // GestureDetector(
            //   onTap: () {
            //   },
            //   child: Container(
            //     width: 30,
            //     height: 30,
            //     alignment: Alignment.center, 
            //     child: Icon(
            //       status,
            //       color: Colors.white,
            //       size: 17,
            //     )
            //   )
            // )
          ]
        )
      )
    );
  }
}