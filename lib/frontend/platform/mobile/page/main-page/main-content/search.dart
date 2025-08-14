import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/button/single_card.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final localProperties = LocalProperties();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: ValueListenableBuilder<Map<String, Map<String, List<RecoModel>>>>(
          valueListenable: localProperties.searchManga,
          builder: (context, searchMap, _) {
            final sourceKey = localProperties.mangaRoot.value;
            final sourceData = searchMap[sourceKey] ?? {'default': [], 'search': []};

            final bool usingDefault = (sourceData['search']?.isEmpty ?? true);
            final List<RecoModel> searchList = usingDefault
                ? sourceData['default']!
                : sourceData['search']!;

            if (searchList.isEmpty) {
              return Center(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        color: Colors.white10,
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      const Text( 
                        'Empty Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const ContentDescrip(
                        description: "you're required to import the manga(s) from\nsource",
                        alignment: 'center',
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

                    int itemCount = searchList.length;

                    if (usingDefault) {
                      itemCount = itemCount - (itemCount % crossAxisCount);
                    }

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
                        final manga = searchList[index];
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
        ),
      ),
    );
  }
}