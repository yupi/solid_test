import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  HSVColor _color = HSVColor.fromColor(Colors.white);
  HSVColor _newColor;

  AnimationController _animationController;
  CurvedAnimation _animation;
  math.Random _gen;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _color = _newColor;
        _newColor = _randomColor();
        _animationController.reset();
      }
    });

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _gen = math.Random(DateTime.now().microsecondsSinceEpoch);
    _newColor = _randomColor();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  HSVColor _randomColor() {
    final color = Color.fromARGB(255, _gen.nextInt(256), _gen.nextInt(256), _gen.nextInt(256));
    return HSVColor.fromColor(color);
  }

  Gradient _randomGradient() {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        _randomColor().toColor(),
        _randomColor().toColor(),
        _randomColor().toColor(),
        _randomColor().toColor(),
        _randomColor().toColor(),
        _randomColor().toColor(),
      ]
    );
  }

  void _onTap() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        body: GestureDetector(
          onTap: _onTap,
          child: AnimatedBuilder(
            animation: _animationController,
            child: Center(child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return _randomGradient().lerpTo(_randomGradient(), _animationController.value)
                  .createShader(bounds);
              },
              child: Text(
                'Hi there',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.w800
                ),
              ),
            )),
            builder: (context, child) => Container(
              color: HSVColor.lerp(_color, _newColor, _animationController.value).toColor(),
              child: RotationTransition(turns: _animation, child: child),
            )
          ),
        ),
    );
  }
}
