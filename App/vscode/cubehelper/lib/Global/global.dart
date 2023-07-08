import 'package:cubehelper/Global/extensions.dart';
import 'package:flutter/rendering.dart';

import 'define.dart';
import 'packet.dart';
import '../Function/optionManager.dart';
import '../Function/firebaseRealtimeDB.dart';

// 모든 매니져류 초기화는 여기서
class Global {
  // onInit Callbacks
  static bool _bInit = false;
  static List<Function()> liOnFinishedLoad = [];

  // account
  static Account me = Account();
  static bool get bIsLogin => !me.isGuest;
  static bool get bIsGuest => me.isGuest;
  static String get googleEamil => me.googleEMail;
  static bool get bHasSelectedCube => selectedCube != null;

  // cube change list
  static Cube_ChangeList cubeChangeList = Cube_ChangeList();
  static Cube_ChangeList get selectedCubeChangeList => cubeChangeList;

  static String get getSelectedCubeInfoURL {
    if (bHasSelectedCube == false) {
      return "";
    }

    return selectedCube.desc_url;
  }

  // cubeList
  static final List<Cube_DB> recvedCubeList = [];
  static List<Cube_DB> get cubeList => recvedCubeList;
  static int get cubeListCount => recvedCubeList.length;

  // selected cube
  static late Cube_DB selectedCube;

  // selected round ui
  static ERoundUI selectedUI = ERoundUI.None;

  static void init() async {
    _bInit = true;

    me.guestSetting();
    cubeChangeList.setDefault();

    await OptionManager.init();

    // 무튼 끝나고
    _bInit &= OptionManager.bInit;

    if (_bInit == true) {
      for (var fpCallback in liOnFinishedLoad) {
        fpCallback();
      }

      G.Log("Global.init complete");
    }
  }

  static bool selectCube(int index) {
    if (index < 0 || index >= cubeListCount) {
      return false;
    }

    selectedCube = recvedCubeList[index];
    return true;
  }

  static void googleLogin(bool bSuccess, String value) {
    if (value.isNullOrEmpty()) {
      me.guestSetting();
    } else {
      me.googleEMail = value;
    }

    me.isGuest = !bSuccess;
  }

  static bool IsLikedListCube(Cube_DB c) {
    return false;
  }
}

class Account {
  String googleEMail = ""; // 구글 아이디만 지원할 예정
  bool isGuest = true;

  // 좋아요 리스트

  guestSetting() {
    googleEMail = "GEUST";
    isGuest = true;
  }
}

// simple card
class SCard {
  String name = "";
  String set = "";
  int collectorNum = 0;

  void setInfo(String n, String s, int n) {
    name = n;
    set = s;
    collectorNum = n;
  }
}

class Cube_DB {
  final String key; // firebase json key
  final String name;
  final String owner;
  final String info;
  final String desc_url;

  Cube_DB(this.key, this.name, this.owner, this.info, this.desc_url);

  factory Cube_DB.fromMap(Map<dynamic, dynamic> map, String firebaseKey) {
    return Cube_DB(
        firebaseKey, map['name'], map['owner'], map['info'], map['desc_url']);
  }

  String getDBKey() {
    return key;
  }
}

class Change {
  bool bIn = false;
  String name = "";
}

class Cube_ChangeList {
  int get count => data.length;
  bool get isNoChange => key.isEmpty && count == 0;

  String key = "";
  List<Change> data = [];

  setDefault() {
    key = "";
    data.clear();
  }
}

enum CubeType {
  Mine,
  Arena,
  MagicOnline,
  Others,

  // etc
}
