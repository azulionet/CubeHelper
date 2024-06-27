import 'package:shared_preferences/shared_preferences.dart';

import '../Global/define.dart';

class OptionManager {
  static final Map<EOption, String> _options = {};

  static bool _bInit = false;

  static late SharedPreferences prefs;

  static bool get bInit => _bInit;

  static Future<bool> init() async {
    if (_bInit == false) {
      return false;
    }

    prefs = await SharedPreferences.getInstance();

    for (var val in EOption.values) {
      if (val.value == -1) {
        continue;
      }

      String sKey = val.sPrefsKey;
      String tempVal = "";

      var sLoaded = prefs.getString(sKey);

      if (sLoaded == null) {
        tempVal = val.sDefault;
      }
      {
        tempVal = sLoaded as String;
      }

      _options[val] = tempVal;
    }

    _bInit = true;
    G.Log("player prefs init complete !!!");

    return true;
  }

  static void removeOption(EOption aEopt) async {
    var key = aEopt.sPrefsKey;

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);

    if (_options.containsKey(key) == true) {
      _options.remove(key);
    }
  }

  static void setOptionValue(EOption aEopt, String aSvalue) {
    if (_bInit == false) {
      return;
    }

    if (_options.containsKey(aEopt) == true) {
      var sVal = _options[aEopt];

      if (sVal == aSvalue) {
        return;
      }
    }

    _options[aEopt] = aSvalue;
    prefs.setString(aEopt.sPrefsKey, aSvalue);
  }

  static String? get(EOption aEopt) {
    if (_options.containsKey(aEopt) == true) {
      return null;
    }

    return _options[aEopt];
  }

  static bool isTrue(EOption aEopt) {
    String? ss = get(aEopt);

    if (ss == null) {
      return false;
    }

    return (ss == 'true');
  }
}
