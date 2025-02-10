import 'package:flutter/material.dart';
import '../../widget/button/single_card.dart';
import '../../widget/schema/text_format.dart';

class Explore extends StatefulWidget {

  final String userToken;

  const Explore({
    super.key,
    required this.userToken
  });

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _hintAnimation;
  late Animation<Color?> _hintColorAnimation;
  late FocusNode _focusNode;
  late AnimationController _controllerFade;
  late Animation<Color?> _colorAnimation;
  late TextEditingController _textEditingController;
  bool _isFadedOut = false;

  late AnimationController _controllerArtist; 
  late Animation<double> _positionAnimation1;
  late Animation<double> _positionAnimation2;
  double position1 = 300; 
  double position2 = 300; 

  final List<String> hints = [
    'Solo Leveling',
  ];

  int _currentHintIndex = 0;

  @override
  void initState() {
    super.initState();

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
      if (_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controllerFade.forward();
        _controller.forward();
      } else if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.reverse();
        _controllerFade.reverse();
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0), // Padding adjustment
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
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
                                onTap: (){
                                  FocusScope.of(context).requestFocus(_focusNode);
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: AnimatedBuilder(
                                    animation: _controllerFade, 
                                    builder: (context, child) {
                                      return Text(
                                        "Search for",
                                        style: TextStyle(
                                          color: _colorAnimation.value, 
                                          fontSize: 13,
                                        ),
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
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: GestureDetector(
                  onTap: () {},
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: widget.userToken == 'verified' 
          ? ListView(
            children: [
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
                  ContentDescrip(description: "you're required to import the resources from\nour offical website.", alignment: 'center')
                ],
              ),
            )
          )
      )
    );
  }
}