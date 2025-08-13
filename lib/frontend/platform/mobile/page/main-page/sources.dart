import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/architecture/cubic/widget/sources_pages.dart'; // must export sourcePage cubit
import 'package:odem/frontend/platform/mobile/page/main-page/source-content/extension.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/source-content/migrate.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/source-content/roots.dart';
import 'package:odem/frontend/platform/mobile/widget/schema/color.dart';

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
      ExtensionPage(),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<sourcePage>();
      cubit.changeSelectedIndex(widget.initialPage);
    });
  }

  void onPageChanged(int page) {
    if (mounted) {
      context.read<sourcePage>().changeSelectedIndex(page);
    }
  }

  Widget _mainWrapperBody() {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: topLevelPages,
    );
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
          pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          onPageChanged(page);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: BlocBuilder<sourcePage, int>(
            builder: (context, selectedIndex) {
              final isSelected = selectedIndex == page;
              return Column(
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white : Colors.white38,
                    ),
                    child: Text(indicator),
                  ),
                  const SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 4,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 0.3,
                          width: double.infinity,
                          color: Colors.white30,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: isSelected ? 1 : 0,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
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
        title: const Text(
          'Sources',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        actions: [
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 10),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.travel_explore_outlined,
                        color: Colors.white, size: 20),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.language, color: Colors.white, size: 20),
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