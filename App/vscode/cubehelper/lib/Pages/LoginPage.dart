import 'package:flutter/material.dart';
import '../MainPage.dart';
import '../Function/firebaseRealtimeDB.dart';

// import 'package:flutter/services.dart';
// void exitApp() {
//   SystemNavigator.pop();
// }

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text('로그인'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
