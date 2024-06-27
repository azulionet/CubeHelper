import 'package:cubehelper/Global/extensions.dart';
import 'package:cubehelper/MainPage.dart';
import 'package:cubehelper/Pages/LoadingPage.dart';
import 'package:cubehelper/Pages/RoundProgressPage.dart';
import 'package:cubehelper/Pages/LifeCounterPage.dart';
import 'package:cubehelper/Pages/AbilitySearchPage.dart';

import 'package:flutter/material.dart';

import 'Global/global.dart';
import 'Global/define.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

void main() async {
  // app global data & module init
  Global.init();
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );

    // a5:17:0d:5f:71:60:00:bb:fa:e0:ea:85:64:fe:3b:d4:b7:d8:07:1c:d8:20:67:b6:0c:75:e7:36:1e:ad:78:ce

    G.Log("firebase init complete");
    "todo : Firebase initialized successfully".toast();
  } catch (e) {
    ("todo : Error occurred while initializing Firebase: $e")
        .toast();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Azu's Cube Helper",
        theme: ThemeData(primaryColor: Colors.amber),
        // home: const MyHomePage(title: "Azu's Cube Helper"),

        initialRoute: '/',
        routes: {
          '/': (context) => const LoadingPage(),
          '/main': (context) => const MainPage(
                title: "Azu's cube helper",
              ),
          '/round': (context) => const RoundProgressPage(),
          '/lifeCounter': (context) => const LifeCounterPage(),
          '/ability': (context) => const AbilitySearchPage(),
        });
    // ,home: LoadingPage());
  }
}
