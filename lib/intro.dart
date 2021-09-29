import 'dart:math';

import 'package:flutter/material.dart';

class MyIntro extends StatefulWidget {
  const MyIntro({Key? key}) : super(key: key);

  @override
  _MyIntroState createState() => _MyIntroState();
}

class _MyIntroState extends State<MyIntro> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _rotateAnimation =
        Tween<double>(begin: 0, end: pi*2).animate(_animationController!);
    _animationController!.repeat();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('전나 돌아')),
        body: Center(
          child: Stack(
            children: [
              Image.asset('assets/circle.png', width: 100, height: 100),
              Transform.translate(offset: const Offset(35, 35),
              child: Image.asset('assets/sunny.png', width: 30, height: 30),),
              Transform.translate(offset: const Offset(45, 45)
                  ,child: 
              AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, widget) {
                    return Transform.rotate(
                        angle: _rotateAnimation!.value,
                        child: Transform.translate(
                          offset: const Offset(50, 0),
                          child: widget,
                        ));
                  },
                  child:Image.asset('assets/saturn.png', width: 10, height: 10)))
            ],
          ),
        ));
  }
}
