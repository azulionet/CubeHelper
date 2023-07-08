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
import 'firebase_options.dart';

void main() async {
  // app global data & module init
  Global.init();

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    G.Log("firebase init complete");
    "todo : Firebase initialized successfully".toast();
  } catch (e) {
    ("todo : Error occurred while initializing Firebase: " + e.toString())
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
          '/': (context) => LoadingPage(),
          '/main': (context) => const MainPage(
                title: "Azu's cube helper",
              ),
          '/round': (context) => RoundProgressPage(),
          '/lifeCounter': (context) => LifeCounterPage(),
          '/ability': (context) => AbilitySearchPage(),
        });
    // ,home: LoadingPage());
  }
}
