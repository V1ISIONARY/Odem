
import 'package:flutter/material.dart';
import '../schema/text_format.dart';

class SourceCard extends StatelessWidget {
  final String? age, language, navigateTo1, navigateTo2;
  final bool within;
  final String sourceTitle, title, version, thumbnail, navigateTo;
  final IconData? icon1, icon2;
  const SourceCard({
    super.key,
    this.age,
    this.language,
    required this.within,
    required this.sourceTitle,
    required this.title,
    required this.version,
    required this.thumbnail,
    required this.navigateTo,
    this.icon1,
    this.icon2,
    this.navigateTo1,
    this.navigateTo2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        within == true
          ? Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
              child: ContentTitle(title: sourceTitle)
            )
          : Container(),
        Container(
          height: 50,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15),
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          thumbnail,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            'lib/resources/image/static/solo.png',
                            fit: BoxFit.cover,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ContentTitle(title: title),
                          ContentDescrip(description: '$language ⋅ $version'),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Row(
                children: [icon1, icon2].where((icon) => icon != null).map((icon) => GestureDetector(
                  child: Container(
                    width: 50,
                    child: Center(
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        )
      ]
    );
  }
}