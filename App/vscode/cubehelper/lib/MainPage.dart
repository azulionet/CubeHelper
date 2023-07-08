import 'package:cubehelper/Global/extensions.dart';
import 'package:flutter/material.dart';
import 'Global/global.dart';
import 'Global/define.dart';
import 'Function/optionManager.dart';
import 'Function/firebaseRealtimeDB.dart';

import 'Pages/Page1.dart';
import 'Pages/Page2.dart';
import 'Pages/Page3.dart';
import 'Pages/Page4.dart';
import 'Pages/Page5.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

enum Page {
  cubeInfo(0),
  cardList(1),
  playTest(2),
  analytics(3),
  cubeList(4);

  const Page(this.value);
  final int value;

  static Page fromInt(int i) {
    return Page.values.firstWhere((x) => x.value == i);
  }
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<StatefulWidget> _pages = [];
  int _index = 4;

  Widget get nowPage => _pages[_index];

  String _titleName = "Azu's cube helper";

  bool _bottomNavVisible = false;

  static const Color _bottomButtonColor = Colors.black;
  static const Color _cubeInfoBackgroundColor = Colors.amber;
  static const Color _cardListBackgroundColor = Colors.yellow;
  static const Color _playTestBackgroundColor = Colors.red;
  static const Color _analyticsBackgroundColor = Colors.orange;
  static const Color _cubeListBackgroundColor = Colors.deepOrange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            _titleName,
            style: const TextStyle(color: Colors.black),
          ),
          leading: Builder(
            builder: (context) => IconButton(
                icon: const Icon(
                  Icons.account_box,
                  color: Colors.black,
                ),
                onPressed: () {
                  G.Log("pressed");

                  Scaffold.of(context).openDrawer(); // Account Drawer
                }),
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                onPressed: () {
                  showOptionBar();
                }),
            Builder(
                builder: (context) => IconButton(
                    icon: const Icon(
                      Icons.palette,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer(); // Misc Drawer
                    }))
          ],
          backgroundColor: Colors.white,
        ),
        drawer: getAccountDrawer(),
        endDrawer: getMISCDrawer(),
        body: nowPage,
        bottomNavigationBar: getBottomNavigationBar());
  }

  @override
  void initState() {
    super.initState();

    uiComponentInit() {
      _pages.add(const Page1(title: "cube info"));
      _pages.add(const Page2(title: "card list"));
      _pages.add(const Page3(title: "play test"));
      _pages.add(const Page4(title: "analytics"));
      _pages.add(Page5(title: "cube list", callback: setTitleName));
      _index = Page.cubeList.value;
    }

    uiComponentInit();
  }

  void setTitleName(String s) {
    if (s.isEmpty) {
      return;
    }

    setState(() {
      _titleName = s;
      _index = 0; // cubelist 4 -> cube info 0
      _bottomNavVisible = true;
    });
  }

  Widget getBottomNavigationBar() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 750),
      opacity: _bottomNavVisible ? 1.0 : 0.0,
      child: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: 'info',
              backgroundColor: _cubeInfoBackgroundColor,
              icon: Icon(Icons.description, color: _bottomButtonColor)),
          BottomNavigationBarItem(
              label: "list",
              backgroundColor: _cardListBackgroundColor,
              icon: Icon(Icons.dashboard, color: _bottomButtonColor)),
          BottomNavigationBarItem(
              label: "play",
              backgroundColor: _playTestBackgroundColor,
              icon: Icon(Icons.smart_display, color: _bottomButtonColor)),
          BottomNavigationBarItem(
              label: "analytics",
              backgroundColor: _analyticsBackgroundColor,
              icon: Icon(Icons.analytics, color: _bottomButtonColor)),
          BottomNavigationBarItem(
              label: "cubes",
              backgroundColor: _cubeListBackgroundColor,
              icon: Icon(Icons.view_list, color: _bottomButtonColor)),
        ],
      ),
    );
  }

  // only for email
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  void sendEmail(String subject, String mailBody) async {
    if (subject.isNotEmpty && mailBody.isNotEmpty) {
      subject.sendEmail(mailBody);
    }
  }

  Widget getAccountDrawer() {
    // login <-> logout
    // mail to 주인장
    //

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blueAccent.withOpacity(0.6),
                  Colors.redAccent.withOpacity(0.6)
                ],
              ),
            ),
            child: const Text(
              'Account Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: () {
              // Update the state of the app
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              // Update the state of the app
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('앱 제작자에게 메일 보내기'),
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();

              Navigator.of(context).pop();

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Send Email'),
                    content: Column(
                      children: <Widget>[
                        TextField(
                          controller: subjectController,
                          decoration:
                              const InputDecoration(hintText: 'Email Subject'),
                        ),
                        Expanded(
                          child: TextField(
                            controller: bodyController,
                            maxLines: null,
                            expands: true,
                            decoration:
                                const InputDecoration(hintText: 'Eamil Body'),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          subjectController.text = "";
                          bodyController.text = "";
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Send'),
                        onPressed: () {
                          String subject = subjectController.text;
                          String mailBody = bodyController.text;

                          if (subject.isEmpty == true) {
                            "제목이 비었습니다.".toast();
                            return;
                          }

                          if (mailBody.isEmpty == true) {
                            "내용이 비었습니다.".toast();
                            return;
                          }

                          sendEmail(subject, mailBody);

                          subjectController.text = "";
                          bodyController.text = "";

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getMISCDrawer() {
    // const PopupMenuItem(child: Text("Life Counter")),
    // const PopupMenuItem(child: Text("Swiss Round")),
    // const PopupMenuItem(child: Text("Round Robin")),
    // const PopupMenuItem(child: Text("Single elimination")),
    // const PopupMenuItem(child: Text("Double elimination")),

    return Drawer(
        child: SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blueAccent.withOpacity(0.6),
                  Colors.redAccent.withOpacity(0.6),
                ],
              ),
            ),
            child: const Text(
              'MTG Misc',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.rocket_launch),
            title: const Text('Life Counter'),
            onTap: () {
              Global.selectedUI = ERoundUI.None;
              Navigator.pushNamed(context, '/lifeCounter');
            },
          ),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Text('Swiss Round'),
            onTap: () {
              Global.selectedUI = ERoundUI.SwissRound;
              Navigator.pushNamed(context, '/round');
            },
          ),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Text('Round Robin'),
            onTap: () {
              Global.selectedUI = ERoundUI.RoundRobin;
              Navigator.pushNamed(context, '/round');
            },
          ),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Text('Single Elimination'),
            onTap: () {
              Global.selectedUI = ERoundUI.SingleElimination;
              Navigator.pushNamed(context, '/round');
            },
          ),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Text('Double Elimination'),
            onTap: () {
              Global.selectedUI = ERoundUI.DoubleElimination;
              Navigator.pushNamed(context, '/round');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('AbilitySearch'),
            onTap: () {
              Global.selectedUI = ERoundUI.None;
              Navigator.pushNamed(context, '/ability');
            },
          )
        ],
      ),
    ));
  }

  void showOptionBar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Options', style: TextStyle(fontSize: 24)),
                CheckboxListTile(
                  title: const Text('Option 1'),
                  value: OptionManager.isTrue(
                      EOption.downloadImagesWhenWifiConnected),
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  title: const Text('Option 2'),
                  value: OptionManager.isTrue(EOption.option2),
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  title: const Text('Option 3'),
                  value: OptionManager.isTrue(EOption.option3),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
