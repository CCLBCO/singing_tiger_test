import 'package:flutter/material.dart';
import 'singing_tiger.dart';
import 'api_service.dart' as api;
import 'test_run.dart';

void main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestRun(),
    );
  }
}
