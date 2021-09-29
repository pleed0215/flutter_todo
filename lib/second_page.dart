import 'dart:math';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _rotateAnimation;
  Animation? _scaleAnimation;
  Animation? _transAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _rotateAnimation =
        Tween<double>(begin: 0, end: pi * 10).animate(_animationController!);
    _scaleAnimation =
        Tween<double>(begin: 1, end: 0).animate(_animationController!);
    _transAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(200, 200))
            .animate(_animationController!);
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Animation example2")),
        body: Center(
            child: Column(
          children: [
            AnimatedBuilder(
              animation: _rotateAnimation!,
              builder: (context, widget) {
                return Transform.rotate(
                    angle: _rotateAnimation!.value,
                    child: Transform.translate(
                        offset: const Offset(200,200),
                        child: Transform.scale(
                          scale: _scaleAnimation!.value,
                          child: widget,
                        )));
              },
              child:
                  const Hero(tag: 'detail', child: Icon(Icons.cake, size: 150)),
            ),
            ElevatedButton(
                onPressed: () {
                  _animationController!.repeat();
                },
                child: const Text('Start animation'))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )));
  }
}
