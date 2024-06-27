import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../Global/global.dart';
import '../Function/firebaseRealtimeDB.dart';
import '../Function/firebaseStorage.dart';

import '../Global/define.dart';
import '../Global/extensions.dart';
import '../Function/googleLogin.dart';

// todo : 언제고 큐브 리스트가 많이 많아진다면 부분 부분 업데이트하는 코드가 필요함

class Page5 extends StatefulWidget {
  const Page5(
      {super.key, required this.title, required Function(String) callback})
      : fpCallback = callback;

  final String title;

  final Function(String) fpCallback;

  @override
  State<Page5> createState() => Page5State();
}

// cube list
class Page5State extends State<Page5> with SingleTickerProviderStateMixin {
  List<bool> _liShow = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  String? _selectedCategory = "All";
  final List<String?> _categories = ["All", "My Cube", "MTG Online"];

  @override
  void initState() {
    super.initState();

    uiComponentInit() {
      _liShow = List<bool>.generate(Global.cubeListCount, (index) => false);

      _animationController = AnimationController(
        duration: const Duration(milliseconds: 390),
        vsync: this,
      );

      _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      );
    }

    uiComponentInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red],
              ),
            ),
            child: _makeRefreshableScrollList(),
          ),
          if (GoolgleLogin.bLogin == false) _getGoogleLoginButton(),
        ],
      ),
    );
  }

  Widget _getGoogleLoginButton() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: SignInButton(
          Buttons.Google,
          text: "Sign in with Google",
          onPressed: () {
            if (GoolgleLogin.bLogin == true) {
              "이미 로그인 되었습니다.".toast();
              return;
            }

            GoolgleLogin.signInWithGoogle(
                onSignInSucceeded: (bSuccess, userEmail) {
              setState(() {
                if (bSuccess == true) {
                  "구글 로그인 완료".toast();

                  ACHFirebaseStorage.requestCardData((_bSuccess) {
                    if (_bSuccess) {
                      "카드 데이터 다운로드 완료".toast();
                    } else {
                      "카드 데이터 다운로드 에러".toast();
                    }
                  });
                } else {
                  "구글 로그인에 실패 하였습니다.".toast();
                }

                Global.googleLogin(bSuccess, userEmail);
              });
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void setParentTitle(String sTitle) {
    widget.fpCallback.call(sTitle);
  }

  bool _isLoading = false;
  Future<void> _refreshCubeList() async {
    setState(() {
      _isLoading = true;
    });

    ACHFirebaseRealtimeDB.requestCubeList((bResult) {
      setState(() {
        _isLoading = false;
      });

      // todo : stamp 에 해당하는 값 db에 넣어서 값 읽고 / 쓰기 최소화

      if (bResult == true) {
        _liShow = List<bool>.generate(Global.cubeListCount, (index) => false);

        G.Log("recved cube list count : ${Global.cubeListCount}");

        // 새 데이터가 리프레시 되었을 떄,
        // _liShow 카운트 같고, true없으면 안해도됨
        // 리스트아이템 데이터 안바뀌었다면 안해도됨 두가지 스테이트 추가해야함
        // setState(() {
        //     _liShow = List<bool>.generate(Global.cubeListCount, (index) => false);
        //       }
      } else {
        // 최소 텀 10분, 혹은 false
      }
    });
  }

  // todo : filter 리스트 정리되면 추가작업 ㅇㅇ
  bool isVisibleFilterUI() {
    bool bVisibleFilterUI = false;

    // String? _selectedCategory = "All";
    // List<String?> _categories = ["All", "My Cube", "MTG Online"];

    return bVisibleFilterUI;
  }

  List<Widget> _getTopUIs() {
    List<Widget> container = [];
    List<Widget> inStack = [];

    setInStackUIs(List<Widget> refStack) {
      refStack.add(const Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Center(
              child: Text(
            "Welcome to Azu's Cube Helper",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ))));

      if (isVisibleFilterUI() == true) {
        refStack.add(Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 28, right: 16.0),
              child: DropdownButton(
                value: _selectedCategory,
                icon: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                dropdownColor: Colors.blue,
                style: const TextStyle(color: Colors.white),
                onChanged: (dynamic value) {
                  _selectedCategory = value;
                },
                items: _categories.map((String? item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text('$item'),
                  );
                }).toList(),
              ),
            )));
      }

      return refStack;
    }

    setInStackUIs(inStack);

    container.add(const SizedBox(height: 20.0));

    if (inStack.isNotEmpty == true) {
      container.add(Stack(children: inStack));
    }

    container.add(SizedBox(
      height: 4.0,
      child: Container(
        color: Colors.indigo,
      ),
    ));

    container.add(const SizedBox(
      height: 16.0,
    ));

    container.add(
        (_isLoading) ? const CircularProgressIndicator() : _makeItemListView());

    container.add(const SizedBox(height: 10.0));

    return container;
  }

  Widget _makeRefreshableScrollList() {
    return RefreshIndicator(
      onRefresh: _refreshCubeList,
      color: Colors.deepPurpleAccent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(bottom: 66),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red],
            ),
          ),
          child: Column(children: _getTopUIs()),
        ),
      ),
    );
  }

  _getCubeListIcon(Cube_DB selectedCube) {
    if (Global.bIsLogin == true) {
      if (Global.isMyCube(selectedCube) == true) {
        return Icons.account_box;
      } else if (Global.isLikedListCube(selectedCube) == true) {
        return Icons.favorite;
      }
    }

    return Icons.label;

    // final String key; // firebase json key
    //final String name;
    //final String owner;
    //final String info;
    //final String desc_url;
  }

  _makeItemListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Global.cubeListCount,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            if (index >= _liShow.length) {
              return;
            }

            if (_liShow[index] == true) {
              setState(() {
                _liShow[index] = false;
                _animationController.reverse();
              });
            } else {
              setState(() {
                _liShow.fillRange(0, _liShow.length, false);
                _liShow[index] = true;

                _animationController.forward(from: 0);
              });
            }
          },
          child: Card(
            color: _liShow[index]
                ? const Color.fromARGB(255, 240, 203, 107)
                : Colors.white.withOpacity(0.7),
            child: ListTile(
              leading: Icon(
                _getCubeListIcon(Global.cubeList[index]),
                size: 36,
              ),
              title: Text(
                Global.cubeList[index].name,
                style: const TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                Global.cubeList[index].info,
                style: const TextStyle(color: Colors.deepPurpleAccent),
              ),
              trailing: makeJestureButton(index),
            ),
          ),
        );
      },
    );
  }

  makeJestureButton(int index) {
    double iconSize = MediaQuery.of(context).size.width * 0.1;

    return _liShow[index] == true
        ? FadeTransition(
            opacity: _animation,
            child: Container(
              padding:
                  const EdgeInsets.all(2.0), // padding은 테두리와 아이콘 사이의 간격을 제어합니다.

              child: ScaleTransition(
                scale: _animation,
                child: IconButton(
                    icon: Icon(
                      Icons.open_in_new,
                      color: Colors.indigoAccent,
                      size: iconSize,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () => _onSelectCubeButtonClicked(index)),
              ),
            ))
        : null;
  }

  Future<void> _onSelectCubeButtonClicked(int index) async {
    G.Log("ACH - _onSelectCubeButtonClicked : $index");

    if (_selectCube(index) == true) {
      if (Global.hasCardList(Global.selectedCube.name) == false) {
        setState(() {
          _isLoading = true; // 로딩 상태로 설정하여 UI 표시
        });

        List<Card_DB> liCards = [];

        await ACHFirebaseRealtimeDB.requestCardList(
            Global.selectedCube.key, liCards);

        if (liCards.isNotEmpty == true) {
          Global.addCubeCardList(Global.selectedCube.name, liCards);
          setParentTitle(Global.cubeList[index].name);
        } else {
          "ACH - download card list error. check internet connection"
              .toastBig();
        }

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      var list = Global.getCubeCardList(Global.selectedCube.name);

      if (list != null) {
        setParentTitle(Global.cubeList[index].name);
      } else {
        "ACH - Error Occured!!".toastBig();
      }
    }
  }

  _selectCube(int index) {
    return Global.selectCube(index);
  }
}
