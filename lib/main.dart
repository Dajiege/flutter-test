import 'package:flutter/material.dart';
import './pages/index.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '测试',
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      routes: {
        '/': (_) => new HomePage()
      },
    );
  }
}
