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

  static void setOptionValue(EOption a_eOpt, String a_sValue) {
    if (_bInit == false) {
      return;
    }

    if (_options.containsKey(a_eOpt) == true) {
      var sVal = _options[a_eOpt];

      if (sVal == a_sValue) {
        return;
      }
    }

    _options[a_eOpt] = a_sValue;
    prefs.setString(a_eOpt.sPrefsKey, a_sValue);
  }

  static String? get(EOption a_eOpt) {
    if (_options.containsKey(a_eOpt) == true) {
      return null;
    }

    return _options[a_eOpt];
  }

  static bool isTrue(EOption a_eOpt) {
    String? ss = get(a_eOpt);

    if (ss == null) {
      return false;
    }

    return (ss == 'true');
  }
}
