import 'package:flutter/material.dart';

import '../../../widget/button/category_card.dart';
import '../../../widget/design/category_compo.dart';
import '../../../widget/button/single_card.dart';
import '../../../widget/schema/text_format.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Transform.translate(
          // offset: Offset(-20, 0),
          offset: Offset(-20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentTitle(title: 'Categories'),
            ],
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 10),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: 15
            ),
            child: CategoryCard(),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    int crossAxisCount = (screenWidth / 150).floor(); 
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount, 
                        mainAxisSpacing: 5, 
                        crossAxisSpacing: 5, 
                        childAspectRatio: 100 / 200, 
                      ),
                      itemCount: 1, 
                      shrinkWrap: true, 
                      physics: const NeverScrollableScrollPhysics(), 
                      padding: const EdgeInsets.symmetric(horizontal: 15), 
                      itemBuilder: (_, index) => GridTile(
                        child: SingleCard(
                          title: 'Solo Leveling',
                          ratings: '4.5',
                          thumbnail: 'lib/resources/image/static/solo.png',
                          description: 'Ep: 23 ⋅ Season: 2', mangaId: 1
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          )
        ]
      ),
    );
  }
}