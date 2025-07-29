import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odem/frontend/platform/mobile/widget/button/menu_card.dart';
import 'package:page_transition/page_transition.dart';

import 'schema/color.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      clipBehavior: Clip.none,
      child: Container(
        width: 200,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(21, 33, 34, 1),
          borderRadius: BorderRadius.zero
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  PageTransition(
                    child: Container(),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200)
                  )
                );
              },
              child: Container(
                height: 60,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'lib/resources/image/static/solo.png', 
                            fit: BoxFit.cover, 
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 40,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              'Sung Ju',
                                style: TextStyle(color: Colors.white, fontSize: 14.0)
                              ),
                              Text(
                              'View Profile',
                                style: TextStyle(color: Colors.white54, fontSize: 10.0)
                              )
                            ],
                          )
                        )
                      )
                    ],
                  )
                )
              )
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white10,
            ),
            MenuCard(
              title: 'Downloaded only', 
              description: 'Filters all entries in your library', 
              svgIcon: Icon(Icons.cloud_off_outlined, color: Colors.white, size: 25), 
              navigateTo: '',
            ),
            MenuCard(
              title: 'Icognito mode', 
              description: 'Pauses reading history', 
              svgIcon: SvgPicture.asset('lib/resources/svg/incognito.svg', color: Colors.white, height: 25, width: 25), 
              navigateTo: '',
            ),
            MenuCard(
              title: 'Import', 
              description: 'Import your downloaded manga here', 
              svgIcon: Icon(Icons.import_export_sharp, color: Colors.white, size: 25), 
              navigateTo: 'Import',
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white10,
              margin: EdgeInsets.only(top: 5),
            ),
            MenuCard(
              title: 'Download queue', 
              description: '', 
              svgIcon: Icon(Icons.download_outlined, color: Colors.white, size: 25), 
              navigateTo: 'Download',
            ),
            MenuCard(
              title: 'Categories', 
              description: '', 
              svgIcon: Icon(Icons.category_outlined, color: Colors.white, size: 25), 
              navigateTo: 'Categories',
            ),
            MenuCard(
              title: 'Statistic', 
              description: '', 
              svgIcon: Icon(Icons.show_chart_outlined, color: Colors.white, size: 25), 
              navigateTo: 'Statistic',
            ),
            MenuCard(
              title: 'Data and storage', 
              description: '', 
              svgIcon: Icon(Icons.storage_outlined, color: Colors.white, size: 25), 
              navigateTo: 'Storage',
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.white10,
              margin: EdgeInsets.only(top: 5),
            ),
            MenuCard(
              title: 'Settings and privacy', 
              description: 'Customize your settings', 
              svgIcon: Icon(Icons.settings, color: Colors.white, size: 25), 
              navigateTo: 'Setting',
            ),
            MenuCard(
              title: 'About', 
              description: 'Information about the application', 
              svgIcon: Icon(Icons.info_outline, color: Colors.white, size: 25), 
              navigateTo: 'About',
            ),
            MenuCard(
              title: 'Help', 
              description: 'You Concern is our priority', 
              svgIcon: Icon(Icons.question_mark_outlined, color: Colors.white, size: 25), 
              navigateTo: 'Help',
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    // Positioned(
                    //   bottom: 21,
                    //   right: 20,
                    //   child: GestureDetector(
                    //     child: Icon(
                    //       Icons.door_front_door_rounded,
                    //       color: Colors.white,
                    //     ),
                    //   )
                    // ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Container(
                              width: 2,
                              height: 18,
                              color: Colors.white
                            ),
                          ),
                          SvgPicture.asset(
                            'lib/resources/svg/visionary.svg',
                            height: 20,
                            width: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Visionary',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10
                                  ),
                                ),
                                Text(
                                  'Prototype 0.0.1',
                                  style: TextStyle(
                                    color: Colors.white24,
                                    fontSize: 8
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }
}