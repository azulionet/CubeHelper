import 'package:flutter/material.dart';
import 'dart:convert';

class Page4 extends StatefulWidget {
  const Page4({super.key, required this.title});

  final String title;

  @override
  State<Page4> createState() => Page4State();
}

// analytics
class Page4State extends State<Page4> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.rocket_launch,
          size: 100.0,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          '준비중입니다.',
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        Text(
          'analystic',
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    )));
  }
}
