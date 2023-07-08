import 'package:cubehelper/Global/extensions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Global/global.dart';
import '../Global/define.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key, required this.title});

  final String title;

  @override
  State<Page1> createState() => Page1State();
}

// cube info
class Page1State extends State<Page1> {
  late Cube_DB selectedCube;
  late Cube_ChangeList changeList;

  @override
  void initState() {
    super.initState();

    G.Log("page 1 initState()");

    selectedCube = Global.selectedCube;
    changeList = Global.selectedCubeChangeList;
  }

  @override
  Widget build(BuildContext context) {
    void __prepareTopUI() {
      showCubeInfoURL = Container();

      String url = Global.getSelectedCubeInfoURL;

      if (url.isNotEmpty) {
        showCubeInfoURL =
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 16.0),
          Text(
            ' - detail link page',
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          TextButton(
            child: Text(url),
            onPressed: () {
              _launchURL(url);
            },
          ),
          showCubeInfoURL,
        ]);
      }
    }

    // 히스토리, 하단부
    void __prepareHistoryWidget() {
      dataWidgets = [];

      int maxData = changeList.count;

      if (maxData > 20) {
        maxData = 20;
      }

      if (maxData == 0) {
        dataWidgets.add(
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8.0),
                Text(
                  "no change",
                  selectionColor: Colors.amber,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                )
              ]),
            ),
          ),
        );
      } else {
        for (int i = 0; i < maxData; i += 2) {
          // if (i + 1 < maxData)
          {
            dataWidgets.add(
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.greenAccent, width: 3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(children: [
                          Icon(
                            Icons.login,
                            color: Colors.blue,
                            weight: 600,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            changeList.data[i].name,
                            selectionColor: Colors.amber,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          )
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 3,
                            color: (i + 1 < maxData)
                                ? Colors.redAccent
                                : Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(children: [
                          Icon(
                            Icons.logout,
                            color:
                                (i + 1 < maxData) ? Colors.blue : Colors.white,
                            weight: 600,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            (i + 1 < maxData)
                                ? changeList.data[i + 1].name
                                : "",
                            selectionColor: Colors.amber,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }

      showMoreButton = Container();
      if (changeList.count > 20) {
        showMoreButton = TextButton(
          child: Text(showMoreData ? 'Show Less Data' : 'Show More Data'),
          onPressed: () {
            setState(() {
              showMoreData = !showMoreData;
            });
          },
        );
      }
    }

    __prepareTopUI();
    __prepareHistoryWidget();

    return Container(
      color: Colors.blue[100],
      child: _mainUI(),
    );
  }

  late Widget showCubeInfoURL;

  List<Widget> dataWidgets = [];
  bool showMoreData = false;
  late Widget showMoreButton;

  void _launchURL(String sURL) async {
    var uri = Uri.parse(sURL);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $sURL';
    }
  }

  /// 상단부

  Widget __topUI() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Cube Info',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            selectedCube.info,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          showCubeInfoURL,
        ]));
  }

  Widget _topUI() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Cube Info',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          selectedCube.info,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        showCubeInfoURL,
      ]),
    );
  }

  Widget _bottomUI() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Display',
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 16.0),
          Column(
            children: dataWidgets,
          ),
          showMoreButton,
        ],
      ),
    );
  }

  Widget _mainUI() {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_topUI(), _bottomUI()],
            )));
  }
}
