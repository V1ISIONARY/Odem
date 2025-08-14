import 'package:flutter/material.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/button/single_card.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';

class Recommend extends StatefulWidget {
  final String userToken;
  const Recommend({
    super.key,
    required this.userToken
  });

  @override
  State<Recommend> createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  final localProperties = LocalProperties();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: widget.userToken == 'verified'
        ? ValueListenableBuilder(
          valueListenable: localProperties.recommendManga,
          builder: (context, recommendList, _) {
            if (recommendList.isEmpty) {
              return Center(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        color: Colors.white10,
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                      Text(
                        'Empty Data',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 2),
                      ContentDescrip(
                        description:"Extensions must be installed or your existing extensions migrated.",
                        alignment: 'center',
                        color: Colors.white38,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    int crossAxisCount = (screenWidth / 150).floor();
                    if (crossAxisCount < 1) crossAxisCount = 1;

                    int itemCount = recommendList.length;
                    itemCount = itemCount - (itemCount % crossAxisCount);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 100 / 200,
                      ),
                      itemCount: itemCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (_, index) {
                        final manga = recommendList[index];
                        return GridTile(
                          child: SingleCard(
                            zipdata: manga,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        )
      : Center(
          child: Container(
            height: 100,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    color: Colors.white10,
                    margin: EdgeInsets.only(bottom: 10)),
                ContentTitle(title: 'Empty Data'),
                ContentDescrip(
                  description:
                      "you're required to import the resources from\nour official website.",
                  alignment: 'center',
                )
              ],
            ),
          ),
        ),
    );
  }
}