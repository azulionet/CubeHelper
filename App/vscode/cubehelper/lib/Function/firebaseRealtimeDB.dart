import 'package:cubehelper/Global/define.dart';
import '../Global/global.dart';

import 'package:firebase_database/firebase_database.dart';

typedef TypeMaker<T> = T Function();
typedef HTTPObjFactoryMake<T> = TypeMaker<T> Function(Map<String, dynamic> arg);
typedef HTTPCallback<T> = bool Function(T dataObject, bool bResult);
typedef TestCallback = void Function(bool bResult);

class ACHFirebaseRealtimeDB {
  // callback 을 잘 ㅇㅇ

  static DateTime? lastCubeRequestedTime;

  static Future<bool> requestCubeList(TestCallback? refCallback) async {
    Future<bool> getCubeList() async {
      bool bResult = false;

      try {
        var dbRef = FirebaseDatabase.instance.ref().child("cubes");

        var event = await dbRef.once();

        if (event.snapshot.value != null) {
          G.Log(event.snapshot.value.toString());

          Map<dynamic, dynamic> data =
              event.snapshot.value as Map<dynamic, dynamic>;

          Global.cubeList.clear();

          data.forEach((key, value) {
            // Cube 객체 생성
            Cube_DB cube = Cube_DB.fromMap(value, key);

            Global.cubeList.add(cube);

            G.Log("parsed cube name : ${cube.name}");
            G.Log("parsed cube info : ${cube.info}");
          });

          Global.sortRecvedCubeList();

          G.Log("receved cube count : ${Global.cubeListCount}");

          bResult = true;
        }
      } catch (e) {
        G.Log(e.toString());
        return false;
      }

      return bResult;
    }

    G.Log("requestCubeList");

    DateTime now = DateTime.now();

    if (lastCubeRequestedTime != null) {
      Duration difference = now.difference(lastCubeRequestedTime!);

      // 최소 10분에 한 번
      if (difference.inMinutes < 10) {
        G.Log("under 10 min to request");

        refCallback?.call(false);
        return false;
      }
    }

    lastCubeRequestedTime = now;

    bool bResult = await getCubeList();

    if (bResult == false) {
      lastCubeRequestedTime = null;
    }

    refCallback?.call(bResult);
    return bResult;
  }

  static Future<bool> requestCardList(
      String cubeKey, List<Card_DB> outCards) async {
    try {
      G.Log("ee");

      var dbRef = FirebaseDatabase.instance
          .ref()
          .child("cardlists")
          .child(cubeKey)
          .child("list");

      var event = await dbRef.once();

      if (event.snapshot.value != null) {
        List<dynamic> snapshotData = event.snapshot.value as List<dynamic>;

        outCards.clear();

        for (var dataMap in snapshotData) {
          if (dataMap is Map<dynamic, dynamic>) {
            String id = dataMap['id'] as String;

            if (Global.mapAllCards.containsKey(id) == true) {
              var storage = Global.mapAllCards[id];

              Card_DB cardDB =
                  Card_DB.fromMap(dataMap, storage as Card_Storage);
              outCards.add(cardDB);

              G.Log("ach - card added");
            } else {
              G.Log("ach - not found card : id [$id]");
            }
          }
        }
            }
    } catch (e) {
      G.Log("ACH - req error : ee");
      G.Log(e.toString());
      return false;
    }

    return true;
  }
}
