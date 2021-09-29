import 'package:flutter/material.dart';

class SliverPage extends StatefulWidget {
  const SliverPage({Key? key}) : super(key: key);

  @override
  _SliverPageState createState() => _SliverPageState();
}

class _SliverPageState extends State<SliverPage> {
  Widget customCardString(String str) {
    return Card(
        child: Center(
      child: Text(str, style: const TextStyle(fontSize: 40)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text("Sliver example"),
            background: Image.asset('assets/sunny.png'),
          ),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        SliverList(delegate: SliverChildListDelegate([
          customCardString('1'),
          customCardString('2'),
          customCardString('3'),
          customCardString('4'),
        ])),
        SliverGrid(delegate: SliverChildListDelegate([
          customCardString('1'),
          customCardString('2'),
          customCardString('3'),
          customCardString('4'),
        ]), gridDelegate: 
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),),
      ],
    ),
    );
  }
}
