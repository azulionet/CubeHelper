import 'package:cubehelper/Global/extensions.dart';

import 'define.dart';
import '../Function/optionManager.dart';

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
  static bool get bHasSelectedCube => selectedCube.name.isNotEmpty;

  // storage card all data
  static Map<String, Card_Storage> mapAllCards = {};

  // cube change list
  static Cube_ChangeList cubeChangeList = Cube_ChangeList();
  static Cube_ChangeList get selectedCubeChangeList => cubeChangeList;

  // cube list
  static final List<Cube_DB> recvedCubeList = [];
  static List<Cube_DB> get cubeList => recvedCubeList;
  static int get cubeListCount => recvedCubeList.length;

  // selected cube cards list
  static final Map<String, List<Card_DB>> mapCubeCards = {};

  // selected cube
  static Cube_DB selectedCube = Cube_DB("", "", "", "", "");

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

  static Cube_DB getSelectedCube() {
    return selectedCube;
  }

  static List<Card_DB>? getCurrentCubeCardList() {
    return mapCubeCards[selectedCube.name];
  }

  static String getSelectedCubeDescriptionURL() {
    return selectedCube.desc_url;
  }

  static getSelectedCubeChangeList() {
    return cubeChangeList;
  }

  static bool isMyCube(Cube_DB c) {
    return c.owner == googleEamil;
  }

  static bool isLikedListCube(Cube_DB c) {
    return false;
  }

  static int _getCubeSortValue(Cube_DB c) {
    if (isMyCube(c) == true) {
      return 2;
    } else if (isLikedListCube(c) == true) {
      return 1;
    } else {
      return 0;
    }
  }

  static void sortRecvedCubeList() {
    recvedCubeList.sort((a, b) {
      int temp1 = _getCubeSortValue(a);
      int temp2 = _getCubeSortValue(b);

      if (temp1 > temp2) {
        return 1;
      } else if (temp1 < temp2) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  static bool hasCardList(String cubeName) {
    return mapCubeCards.containsKey(cubeName);
  }

  static void addCubeCardList(String cubeName, List<Card_DB> liCards) {
    mapCubeCards[cubeName] = liCards;
  }

  static List<Card_DB>? getCubeCardList(String cubeName) {
    return mapCubeCards[cubeName];
  }

  static bool selectCube(int index) {
    if (index < 0 || index >= cubeListCount) {
      return false;
    }

    selectedCube = recvedCubeList[index];
    return true;
  }

  static void googleLogin(bool bSuccess, String email) {
    if (email.isNullOrEmpty()) {
      me.guestSetting();
    } else {
      me.googleEMail = email;
    }

    me.isGuest = !bSuccess;

    G.Log("ACH - google login ${(bSuccess == true) ? "success" : "fail"}");
  }

  static void cacheReset() {
    EOption.cardDataUpdateTime.removeOption();

    G.Log("ACH - Cache Reset");
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
  late Card_DB refCardDB;

  void setDB(Card_DB val) {
    refCardDB = val;
  }

  void setInfo(String n, String s, int cn) {
    name = n;
    set = s;
    collectorNum = cn;
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

class Card_DB {
  final String id;
  final String tag;
  late Card_Storage refStorage;

  Card_DB(this.id, this.tag, this.refStorage);

  factory Card_DB.fromMap(Map<dynamic, dynamic> map, Card_Storage storage) {
    return Card_DB(map['id'], map['tag'], storage);
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

class Card_Storage {
  final String id;
  final String name;
  final String set;
  final String manaCost;
  final String rarity;
  final String typeLine;
  final String collectorNumber;
  final String smallImageUrl;
  final String normalImageUrl;

  Card_Storage({
    required this.id,
    required this.name,
    required this.set,
    required this.manaCost,
    required this.rarity,
    required this.typeLine,
    required this.collectorNumber,
    required this.smallImageUrl,
    required this.normalImageUrl,
  });

  // JSON에서 CardData 객체로 변환하는 팩토리 메서드
  factory Card_Storage.fromJson(Map<String, dynamic> json) {
    return Card_Storage(
      id: json['id'] as String? ?? '',
      name: json['n'] as String? ?? '',
      set: json['s'] as String? ?? '',
      manaCost: json['m'] as String? ?? '',
      rarity: json['r'] as String? ?? '',
      typeLine: json['t'] as String? ?? '',
      collectorNumber: json['cn'] as String? ?? '',
      smallImageUrl: json['us'] as String? ?? '',
      normalImageUrl: json['un'] as String? ?? '',
    );
  }

  // CardData 객체에서 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'set': set,
      'mana_cost': manaCost,
      'rarity': rarity,
      'type_line': typeLine,
      'collector_number': collectorNumber,
      'small_image_url': smallImageUrl,
      'normal_image_url': normalImageUrl,
    };
  }
}
