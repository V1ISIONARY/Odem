import 'package:flutter/material.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/menu-content/category.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/menu-content/download.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/menu-content/help.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/menu-content/import.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/menu-content/setting.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/menu-content/statistic.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/menu-content/storage.dart';
import 'package:page_transition/page_transition.dart';

import '../../page/main-page/menu-content/about.dart';

class MenuCard extends StatefulWidget {
  final String title;
  final String description;
  final Widget svgIcon; 
  final String navigateTo;

  const MenuCard({
    super.key,
    required this.title,
    required this.description,
    required this.svgIcon,
    required this.navigateTo,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.navigateTo.isNotEmpty) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: _getNavigateToScreen(widget.navigateTo),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 300),
                  ),
                );
              }
            },
            child: Container(
              height: 40,
              width: double.infinity,
              color: Color.fromRGBO(21, 33, 34, 1),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.svgIcon, 
                    SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        if (widget.description.isNotEmpty)
                          Text(
                            widget.description,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getNavigateToScreen(String navigateTo) {
    switch (navigateTo) {
      case 'Import':
        return Import();
      case 'Download':
        return Download();
      case 'Categories':
        return Category();
      case 'Statistic':
        return Statistic();
      case 'Storage':
        return Storage();
      case 'Setting':
        return Setting();
      case 'About':
        return About();
      case 'Help':
        return Help();
      default:
        return Container();
    }
  }
}
