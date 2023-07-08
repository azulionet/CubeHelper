import 'dart:convert';
import 'dart:math';
import 'package:cubehelper/Global/define.dart';
import 'package:http/http.dart' as http;
import '../Global/global.dart';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';

typedef TypeMaker<T> = T Function();
typedef HTTPObjFactoryMake<T> = TypeMaker<T> Function(Map<String, dynamic> arg);
typedef HTTPCallback<T> = bool Function(T dataObject, bool bResult);
typedef TestCallback = void Function(bool bResult);

class FirebaseRealtimeDB {
  // callback 을 잘 ㅇㅇ

  static DateTime? lastCubeRequestedTime;

  static Future<bool> requestCubeList(TestCallback? refCallback) async {
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

    bool bResult = await _getCubeList();

    if (bResult == false) {
      lastCubeRequestedTime = null;
    }

    refCallback?.call(bResult);
    return bResult;
  }
}

Future<bool> _getCubeList() async {
  bool bResult = false;

  try {
    var dbRef = FirebaseDatabase.instance.ref().child("cubes");

    var event = await dbRef.once();

    if (event.snapshot.value != null) {
      G.Log(event.snapshot.value.toString());

      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;

      if (data == null) {
        G.Log(" ? data in null ");
        return false;
      }

      Global.cubeList.clear();

      data.forEach((key, value) {
        // Cube 객체 생성
        Cube_DB cube = Cube_DB.fromMap(value, key);

        Global.cubeList.add(cube);

        G.Log("parsed cube name : " + cube.name);
        G.Log("parsed cube info : " + cube.info);
      });

      G.Log("receved cube count : " + Global.cubeListCount.toString());

      bResult = true;
    }
  } catch (e) {
    G.Log(e.toString());
    return false;
  }

  return bResult;
}
