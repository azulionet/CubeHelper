import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key, required this.title});

  final String title;

  @override
  State<Page3> createState() => Page3State();
}

// play test
class Page3State extends State<Page3> {
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
          Icons.waving_hand,
          size: 100.0,
          color: Theme.of(context).primaryColor,
        ),
        const Text(
          '준비중입니다.',
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        const Text(
          'play test',
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    )));
  }
}
