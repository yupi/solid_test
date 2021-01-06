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
  math.Random _gen;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _color = _newColor;
        _newColor = _randomColor();
        _animationController.reset();
      }
    });

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
        body: AnimatedBuilder(
          animation: _animationController,
          child: Center(child: Text('Hi there')),
          builder: (context, child) {
            final _animation = CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOutCubic,
            );

            return GestureDetector(
              onTap: _onTap,
              child: Container(
                color: HSVColor.lerp(_color, _newColor, _animationController.value).toColor(),
                child: RotationTransition(
                  turns: _animation,
                  child: child,
                ),
              ),
            );
          }
        ),
    );
  }
}
