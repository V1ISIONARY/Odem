import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odem/backend/architecture/cubic/widget/main_page.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/explore.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/history.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/library.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/sources.dart';
import 'package:odem/frontend/platform/mobile/widget/drawer.dart';

class BottomNavigation extends StatefulWidget {
  final int initialPage; 
  const BottomNavigation({
    super.key,
    required this.initialPage,
  }); 

  @override
  State<BottomNavigation> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController pageController;
  late AnimationController _controller;
  late Animation<Alignment> _beginAnimation;
  late Animation<Alignment> _endAnimation;

  late List<Widget> topLevelPages;

  void drawerOpen() {
    setState(() {
      _scaffoldKey.currentState?.openDrawer();
    });
  }

  @override
  void initState() {

    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
    topLevelPages = _initializeTopLevelPages(); 
  
  }

  void onPageChanged(int page) {
    BlocProvider.of<mainPage>(context).changeSelectedIndex(page);
  }

  @override
  void dispose() {
    // _controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  List<Widget> _initializeTopLevelPages() {
    return [
      Explore(userToken: 'verified', drawble: drawerOpen),
      const Library(),
      const History(),
      const Sources(initialPage: 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent, 
      body: _mainWrapperBody(),
      bottomNavigationBar: _BottomNavigationBottomNavBar(context),
      drawer: DrawerWidget()
    );
  }

  Widget _BottomNavigationBottomNavBar(BuildContext context) {
    return BottomAppBar(
      height: 69,
      color: Colors.black, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _bottomAppBarItem(
                  context,
                  icon: Icons.home,
                  svgIcon: 'lib/resources/svg/explore.svg',
                  page: 0,
                  label: "Explore",
                ),
                _bottomAppBarItem(
                  context,
                  icon: Icons.my_library_books_outlined, 
                  svgIcon: '',
                  page: 1,
                  label: "Library",
                ),
                _bottomAppBarItem(
                  context,
                  icon: Icons.history,
                  svgIcon: '',
                  page: 2,
                  label: "History",
                ),
                _bottomAppBarItem(
                  context,
                  icon: Icons.flutter_dash, 
                  svgIcon: '', 
                  page: 3,
                  label: "Sources",
                )
              ],
            ),
          ),
        ],
      )
    );
  }


  PageView _BottomNavigationBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: topLevelPages,
    );
  }

  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: topLevelPages,
    );
  }

  double iconSize = 20.0;
  double fontSize = 8.0;

  Widget _bottomAppBarItem(
    BuildContext context, {
    required IconData icon,
    required String svgIcon,
    required int page,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        pageController.jumpToPage(page);
        onPageChanged(page);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<mainPage, int>(
            builder: (context, selectedIndex) {
              bool isSelected = selectedIndex == page;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: svgIcon.isNotEmpty
                    ? SvgPicture.asset(
                        svgIcon,
                        height: iconSize,
                        color: isSelected ? Colors.white : Colors.grey,
                      )
                    : Icon(
                        icon,
                        size: iconSize,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

}