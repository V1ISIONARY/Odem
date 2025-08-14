import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odem/backend/architecture/bloc/manga/manga_bloc.dart';
import 'package:odem/backend/model/manga/recommend.dart';
import 'package:odem/backend/properties/local_properties.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/recommend.dart';
import 'package:odem/frontend/platform/mobile/page/main-page/main-content/search.dart';
import '../../widget/bottom_navigation.dart';
import '../../widget/button/single_card.dart';
import '../../widget/schema/text_format.dart';

class Explore extends StatefulWidget {

  final String userToken;
  final VoidCallback drawble;

  const Explore({
    super.key,
    required this.userToken,
    required this.drawble
  });

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<BottomNavigationState> drawerOpen = GlobalKey<BottomNavigationState>();
  final localProperties = LocalProperties();
  late AnimationController _controller;
  late Animation<Offset> _hintAnimation;
  late Animation<Color?> _hintColorAnimation;
  late FocusNode _focusNode;
  late AnimationController _controllerFade;
  late Animation<Color?> _colorAnimation;
  late TextEditingController _textEditingController;
  bool _isSearching = false;
  bool _isFadedOut = false;

  late AnimationController _controllerArtist; 
  late Animation<double> _positionAnimation1;
  late Animation<double> _positionAnimation2;
  double _rightContainerWidth = 0;
  double position1 = 300; 
  double position2 = 300; 

  final List<String> hints = [
    'Solo Leveling',
    'Level 999 Goblin'
  ];

  int _currentHintIndex = 0;

  late final AnimationController _fadeSearchCtrl;
  late final AnimationController _fadeRecommendCtrl;
  late final Animation<double> _opSearch;
  late final Animation<double> _opRecommend;
  bool _ignoreRecommend = false;
  bool _ignoreSearch = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textEditingController.addListener(() {
        final text = _textEditingController.text.trim();
        setState(() {
          _rightContainerWidth = text.isNotEmpty ? 40 : 0;
        });
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controllerFade = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controllerArtist = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _positionAnimation1 = Tween<double>(begin: 400, end: -200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _positionAnimation2 = Tween<double>(begin: 600, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controllerArtist.repeat();

    _hintAnimation = Tween<Offset>(
      begin: Offset(0, 0), 
      end: Offset(0, -1), 
    ).animate(_controller);

    _hintColorAnimation = ColorTween(
      begin: Colors.white.withOpacity(0.5), 
      end: const Color.fromARGB(0, 148, 37, 37), 
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.white70, 
      end: Colors.transparent, 
    ).animate(_controllerFade);

    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _changeHintText();

    _focusNode.addListener(() {
      final Map<String, Map<String, List<RecoModel>>> currentMap =
          localProperties.searchManga.value.map((k, v) {
        final inner = v.map((typeKey, list) =>
            MapEntry(typeKey, List<RecoModel>.from(list)));
        return MapEntry(k, inner);
      });
      if (_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        localProperties.onSearchPage.value = true;
        _controllerFade.forward();
        _controller.forward();
      } else if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        localProperties.onSearchPage.value = false;
        currentMap.forEach((source, typeMap) {
          typeMap['search'] = <RecoModel>[]; 
        });
        localProperties.searchManga.value = currentMap;
        _controller.reverse();
        _controllerFade.reverse();
      }
    });

    _fadeSearchCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeRecommendCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opSearch = CurvedAnimation(parent: _fadeSearchCtrl, curve: Curves.easeInOut);
    _opRecommend = CurvedAnimation(parent: _fadeRecommendCtrl, curve: Curves.easeInOut);

    if (localProperties.onSearchPage.value) {
      _fadeSearchCtrl.value = 1.0;
      _fadeRecommendCtrl.value = 0.0;
      _ignoreSearch = false;
      _ignoreRecommend = true;
    } else {
      _fadeSearchCtrl.value = 0.0;
      _fadeRecommendCtrl.value = 1.0;
      _ignoreSearch = true;
      _ignoreRecommend = false;
    }

    _fadeSearchCtrl.addStatusListener((status) {
      bool newIgnoreSearch = status != AnimationStatus.completed;
      bool newIgnoreRecommend = status == AnimationStatus.completed;

      if (newIgnoreSearch != _ignoreSearch || newIgnoreRecommend != _ignoreRecommend) {
        setState(() {
          _ignoreSearch = newIgnoreSearch;
          _ignoreRecommend = newIgnoreRecommend;
        });
      }
    });

    _fadeRecommendCtrl.addStatusListener((status) {
      bool newIgnoreRecommend = status != AnimationStatus.completed;
      bool newIgnoreSearch = status == AnimationStatus.completed;

      if (newIgnoreRecommend != _ignoreRecommend || newIgnoreSearch != _ignoreSearch) {
        setState(() {
          _ignoreRecommend = newIgnoreRecommend;
          _ignoreSearch = newIgnoreSearch;
        });
      }
    });

    localProperties.onSearchPage.addListener(() {
      if (localProperties.onSearchPage.value) {
        _fadeSearchCtrl.forward();
        _fadeRecommendCtrl.reverse();
      } else {
        _fadeSearchCtrl.reverse();
        _fadeRecommendCtrl.forward();
      }
    });
  }

  void _toggleTextVisibility() {
    if (_isFadedOut) {
      _controllerFade.reverse();
    } else {
      _controllerFade.forward();
    }

    setState(() {
      _isFadedOut = !_isFadedOut;
    });
  }
  
  void _changeHintText() {
    Future.delayed(Duration(seconds: 2), () {
      if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.forward().then((_) {
          setState(() {
            _currentHintIndex = (_currentHintIndex + 1) % hints.length;
          });
          _controller.reverse().then((_) {
            _changeHintText(); 
          });
        });
      } else {
        _changeHintText();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerFade.dispose();
    _controllerArtist.dispose(); 
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                child: Center(
                  child: GestureDetector(
                    onTap: widget.drawble,
                    child: Container(
                      height: 25,
                      width: 25,
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
                  ),
                )
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Container(
                            height: 30,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: TextField(
                                    controller: _textEditingController,
                                    cursorColor: Colors.white,
                                    focusNode: _focusNode,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.black,
                                      hintText: '', 
                                      hintStyle: TextStyle(
                                        color: Colors.transparent, 
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          topRight: _rightContainerWidth > 0 ? Radius.circular(0) : Radius.circular(5.0),
                                          bottomRight: _rightContainerWidth > 0 ? Radius.circular(0) : Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          topRight: _rightContainerWidth > 0 ? Radius.circular(0) : Radius.circular(5.0),
                                          bottomRight: _rightContainerWidth > 0 ? Radius.circular(0) : Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                          topRight: _rightContainerWidth > 0 ? Radius.circular(0) : Radius.circular(5.0),
                                          bottomRight: _rightContainerWidth > 0 ? Radius.circular(0) : Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6.3,
                                  left: 12, 
                                  right: 12,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).requestFocus(_focusNode);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 4),
                                          child: AnimatedBuilder(
                                            animation: _controllerFade, 
                                            builder: (context, child) {
                                              return Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.search,
                                                    size: 15,
                                                    color: _colorAnimation.value,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Search for",
                                                    style: TextStyle(
                                                      color: _colorAnimation.value, 
                                                      fontSize: 13,
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SlideTransition(
                                        position: _hintAnimation,
                                        child: AnimatedBuilder(
                                          animation: _hintColorAnimation,
                                          builder: (context, child) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context).requestFocus(_focusNode);
                                              },
                                              child: Text(
                                                hints[_currentHintIndex],
                                                style: TextStyle(
                                                  color: _hintColorAnimation.value, 
                                                  fontSize: 13,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    BlocListener<MangaBloc, MangaState>(
                      listener: (context, state) {
                        if (state is LoadingSearch) { 
                          setState(() {
                            _isSearching = true;
                          });
                        } else if (state is FetchSearch || state is ErrorOdem) {
                          setState(() {
                            _isSearching = false;
                          });
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          context.read<MangaBloc>().add(LoadSearch(
                            _textEditingController.text,
                            localProperties.mangaRoot.value,
                            true
                          ));
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: _rightContainerWidth,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: _isSearching
                              ? SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : Icon(
                                  Icons.send,
                                  size: 15,
                                  color: Colors.black,
                                ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: GestureDetector(
                  child: Transform.translate(
                    offset: Offset(3, 0),
                    child: Container(
                      height: 50,
                      width: 40,
                      child: Center(
                        child: Icon(
                          Icons.widgets_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: _ignoreRecommend,
            child: FadeTransition(
              opacity: _opRecommend,
              child: Recommend(userToken: widget.userToken)
            )
          ),
          IgnorePointer(
            ignoring: _ignoreSearch,
            child: FadeTransition(
              opacity: _opSearch,
              child: Search(),
            ),
          )
        ],
      ),
    );
  }
}