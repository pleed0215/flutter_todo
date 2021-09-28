import 'package:flutter/material.dart';
import 'package:flutter_todo/people.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const AnimationApp());
  }
}

class AnimationApp extends StatefulWidget {
  const AnimationApp({Key? key}) : super(key: key);

  @override
  _AnimationAppState createState() => _AnimationAppState();
}

class _AnimationAppState extends State<AnimationApp> {
  List<People> peoples = List.empty(growable: true);
  int current = 0;

  @override
  void initState() {
    super.initState();
    peoples.add(People(name: '스미스', height: 180, weight: 92));
    peoples.add(People(name: '메리', height: 162, weight: 55));
    peoples.add(People(name: '존', height: 177, weight: 75));
    peoples.add(People(name: '바트', height: 130, weight: 40));
    peoples.add(People(name: '콘', height: 194, weight: 140));
    peoples.add(People(name: '디디', height: 100, weight: 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Animation Example')),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  child: Row(
                      children: [
                        SizedBox(
                            width: 100,
                            child: Text('이름: ${peoples[current].name}')),
                        AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.bounceIn,
                            color: Colors.amber,
                            child: Text('키 ${peoples[current].height}',
                                textAlign: TextAlign.center),
                            width: 50,
                            height: peoples[current].height),
                        AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInCubic,
                            color: Colors.blue,
                            child: Text('몸무게 ${peoples[current].weight}',
                                textAlign: TextAlign.center),
                            width: 50,
                            height: peoples[current].weight),
                        AnimatedContainer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.linear,
                            color: Colors.pinkAccent,
                            child: Text('BMI ${peoples[current].bmi}',
                                textAlign: TextAlign.center),
                            width: 50,
                            height: peoples[current].bmi),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end),
                  height: 200),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (current < peoples.length - 1) {
                        current++;
                      }
                    });
                  },
                  child: const Text("다음")),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (current > 0) {
                        current--;
                      }
                    });
                  },
                  child: const Text("이전"))
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ));
  }
}
