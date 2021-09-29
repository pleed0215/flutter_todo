import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class FirebaseApp extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  const FirebaseApp({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  @override
  _FirebaseAppState createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  String _message = '';

  void setMessage(String msg) {
    setState(() {
      _message = msg;
    });
  }

  Future<void> _sendAnalyticEvent() async {
    await widget.analytics.logEvent(
        name: 'test_event',
        parameters: <String, dynamic>{'string': 'Hello flutter', 'int': 100});
    setMessage('Analytics 보내기 성공');
  }

  _FirebaseAppState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase example')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: _sendAnalyticEvent, child: const Text('Analyticis 테스트')),
            Text(_message, style: const TextStyle(color: Colors.blueAccent))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
      ),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.tab), onPressed: (){}),
    );
  }
}
