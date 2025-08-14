import 'package:flutter/material.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/recommend.dart';
import 'package:odem/frontend/platform/mobile/widget/button/single_card.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';

class Library extends StatefulWidget {

  final String userToken;
  const Library({
    super.key,
    required this.userToken
  });

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final localProperties = LocalProperties();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Library',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white
          ),
        ),
        actions: [
          Container(
            width: 100,
            margin: EdgeInsets.only(right: 10),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: Icon(Icons.search_outlined, color: Colors.white, size: 20)
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: Icon(Icons.widgets_outlined, color: Colors.white, size: 20)
                  ),
                ),
              ]
            ),
          )
        ],
      ),
      // body: Container(
      //   width: double.infinity,
      //   height: double.infinity,
      //   color: Colors.transparent,
      //   child: widget.userToken == 'verified'
      //     ? ValueListenableBuilder(
      //       valueListenable: localProperties.recommendManga,
      //       builder: (context, recommendList, _) {
      //         if (recommendList.isEmpty) {
      //           return Center(
      //             child: Container(
      //               color: Colors.transparent,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Container(
      //                     height: 80,
      //                     width: 80,
      //                     color: Colors.white10,
      //                     margin: EdgeInsets.only(bottom: 10),
      //                   ),
      //                   Text(
      //                     'Empty Data',
      //                     style: const TextStyle(
      //                       color: Colors.white54,
      //                       fontSize: 15,
      //                     ),
      //                   ),
      //                   SizedBox(height: 2),
      //                   ContentDescrip(
      //                     description:"Extensions must be installed or your existing extensions migrated.",
      //                     alignment: 'center',
      //                     color: Colors.white38,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         }
      //         return ListView(
      //           children: [
      //             LayoutBuilder(
      //               builder: (context, constraints) {
      //                 double screenWidth = constraints.maxWidth;
      //                 int crossAxisCount = (screenWidth / 150).floor();
      //                 if (crossAxisCount < 1) crossAxisCount = 1;

      //                 int itemCount = recommendList.length;
      //                 itemCount = itemCount - (itemCount % crossAxisCount);
      //                 return GridView.builder(
      //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                     crossAxisCount: crossAxisCount,
      //                     mainAxisSpacing: 5,
      //                     crossAxisSpacing: 5,
      //                     childAspectRatio: 100 / 200,
      //                   ),
      //                   itemCount: itemCount,
      //                   shrinkWrap: true,
      //                   physics: const NeverScrollableScrollPhysics(),
      //                   padding: const EdgeInsets.symmetric(horizontal: 15),
      //                   itemBuilder: (_, index) {
      //                     final manga = recommendList[index];
      //                     return GridTile(
      //                       child: SingleCard(
      //                         zipdata: manga,
      //                       ),
      //                     );
      //                   },
      //                 );
      //               },
      //             ),
      //           ],
      //         );
      //       },
      //     )
      //     : Center(
      //         child: Container(
      //           height: 100,
      //           color: Colors.transparent,
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               Container(
      //                   height: 50,
      //                   width: 50,
      //                   color: Colors.white10,
      //                   margin: EdgeInsets.only(bottom: 10)),
      //               ContentTitle(title: 'Empty Data'),
      //               ContentDescrip(
      //                 description:
      //                     "you're required to import the resources from\nour official website.",
      //                 alignment: 'center',
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
    );
  }
}