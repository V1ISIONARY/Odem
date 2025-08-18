import 'package:flutter/material.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/widget/button/category_card.dart';
import 'package:odem/frontend/platform/mobile/widget/button/library_card.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/text_format.dart';

class Library extends StatefulWidget {
  final String userToken;
  const Library({
    super.key,
    required this.userToken,
  });

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final localProperties = LocalProperties();
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      _refreshLibraryManga();
    });
  }

  void _refreshLibraryManga() {
    final Map<String, List<RecoModel>> libraryDataMap = localProperties.libraryData.value;

    List<RecoModel> result;
    if (selectedCategory.toLowerCase() == "all") {
      result = libraryDataMap.values
          .expand<RecoModel>((list) => list)
          .toList();
    } else {
      final normalizedKey = selectedCategory.toLowerCase().replaceAll('.', '-');
      result = List<RecoModel>.from(libraryDataMap[normalizedKey] ?? const <RecoModel>[]);
    }

    result.sort((a, b) {
      final aDate = (a.updatedAt);
      final bDate = (b.updatedAt);
      return bDate.compareTo(aDate);
    });

    localProperties.libraryManga.value = result;
  }

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
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        actions: [
          Container(
            width: 50,
            margin: EdgeInsets.only(right: 10),
            color: Colors.transparent,
            child: Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.search_outlined, color: Colors.white, size: 20)
                ),
              ),
            ]),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: widget.userToken == 'verified'
          ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: CategoryCard(
                    selectedCategory: selectedCategory,
                    onCategoryChanged: (label) {
                      setState(() {
                        selectedCategory = label;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<RecoModel>>(
                    valueListenable: localProperties.libraryManga,
                    builder: (context, libraryManga, _) {
                      if (libraryManga.isEmpty) {
                        return const Center(
                          child: Text(
                            "No data available in this list",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
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
                              return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 100 / 200,
                                ),
                                itemCount: libraryManga.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                itemBuilder: (_, index) {
                                  final manga = libraryManga[index];
                                  return GridTile(
                                    child: LibraryCard(
                                      zipdata: manga,
                                      disableTap: false,
                                      showCircle: selectedCategory.toLowerCase() == "all"
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
              ],
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
                      margin: EdgeInsets.only(bottom: 10)
                    ),
                    ContentTitle(title: 'Empty Data'),
                    ContentDescrip(
                      description: "you're required to import the resources from\nour official website.",
                      alignment: 'center',
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}