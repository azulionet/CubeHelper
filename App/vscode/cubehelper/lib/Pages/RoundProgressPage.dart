import 'package:flutter/material.dart';

class RoundProgressPage extends StatelessWidget {
  const RoundProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Round Progress'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'oijfeoijf',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'lllllllll',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
