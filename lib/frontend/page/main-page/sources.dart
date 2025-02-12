import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/cubic/sources_pages.dart';
import 'package:odem/frontend/page/main-page/source-content/extension.dart';
import 'package:odem/frontend/page/main-page/source-content/migrate.dart';
import 'package:odem/frontend/page/main-page/source-content/roots.dart';
import 'package:odem/frontend/widget/schema/color.dart';

class Sources extends StatefulWidget {
  final int initialPage;
  const Sources({
    super.key,
    required this.initialPage,
  });

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late PageController pageController;
  late List<Widget> topLevelPages;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.initialPage);
    topLevelPages = [
      Roots(),
      Extension(),
      Migrate(),
    ];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
        }
      });

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  void onPageChanged(int page) {
    if (mounted) {
      BlocProvider.of<sourcePage>(context, listen: false)
          .changeSelectedIndex(page);
    }
  }

  Widget _mainWrapperBody() {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: topLevelPages,
    );
  }

  void _startShake() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget _bodyNavigator(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomAppBarItem("Roots", 0),
          _bottomAppBarItem("Extension", 1),
          _bottomAppBarItem("Migrate", 2),
        ],
      ),
    );
  }

  Widget _bottomAppBarItem(String indicator, int page) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          pageController.jumpToPage(page);
          onPageChanged(page);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: BlocBuilder<sourcePage, int>(
            builder: (context, selectedIndex) {
              final isSelected = selectedIndex == page;
              return Column(
                children: [
                  Text(
                    indicator,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white : Colors.white38,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 4,
                      width: double.infinity,
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: 0.3,
                          color: Colors.white30,
                          child: isSelected
                            ? Container(
                                width: double.infinity,
                                height: 5.0,
                                color: Colors.white,
                              )
                            : SizedBox(),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'Sources',
          style: TextStyle(fontSize: 15, color: Colors.white),
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
                    onTap: () {},
                    child: Icon(Icons.travel_explore_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.language, color: Colors.white, size: 20),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _bodyNavigator(context),
          Expanded(child: _mainWrapperBody()),
        ],
      ),
    );
  }
}
