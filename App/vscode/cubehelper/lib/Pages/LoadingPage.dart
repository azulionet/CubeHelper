import 'package:flutter/material.dart';
import '../MainPage.dart';
import 'package:http/http.dart' as http;
import '../Function/firebaseRealtimeDB.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  double loadingValue = 0;
  bool bVisibleButton = false;
  int nSuccessCount = 0;

  Future<bool> waitProgressUI() async {
    while (loadingValue < 1) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        loadingValue += 0.07;
      });

      if (loadingValue >= 1) {
        loadingValue = 1;
        ++nSuccessCount;
        break;
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() async {
    nSuccessCount = 0;
    var response2 = FirebaseRealtimeDB.requestCubeList(null);
    var response3 = waitProgressUI();

    response2.then((value) {
      setState(() {
        loadingValue += 0.6;

        if (loadingValue >= 1) {
          loadingValue = 1;
        }
        if (value == true) {
          ++nSuccessCount;
        }
      });
    });

    await Future.wait([response2, response3]);

    if (loadingValue >= 1) {
      loadingValue = 1;

      bVisibleButton = true;
    }

    // 프로그레스바가 꽉 찬 상태를 잠시 동안 보여줍니다.
    await Future.delayed(const Duration(microseconds: 3000));

    var val = ModalRoute.of(context);

    if (val != null && val.isCurrent == true) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Azu's cube helper",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Visibility(
                    visible: bVisibleButton,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/main');
                      },
                      child: const Text('Continue',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: loadingValue,
                backgroundColor: Colors.white.withOpacity(0.5),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
