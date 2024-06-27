import 'dart:developer';

// ACH - Azu's Cube Helper

class G {
  static void Log(String s) {
    log("ACH - $s");
  }
}

enum EOption {
  // 설정 (UI) 을 통한 값들
  downloadImagesWhenWifiConnected(
      1, "downloadImagesWhenWifiConnected", "true", bool),

  option2(2, "option2", "true", bool),

  option3(3, "option3", "true", bool),

  // 프로그램 전역 데이터
  __seperator__(-1, "", "", Type),

  cardDataUpdateTime(1000, "cardUpdateDate", "", String), // DateTime
  __end__(-1, "", "", Type);

  const EOption(this.value, this.sPrefsKey, this.sDefault, this.treat);
  final int value;
  final String sPrefsKey;
  final String sDefault;
  final Type treat;

  static EOption fromInt(int i) {
    return EOption.values.firstWhere((x) => x.value == i);
  }

  static EOption fromString(String s) {
    return EOption.values.firstWhere((x) => x.sPrefsKey == s);
  }
}

enum ERoundUI {
  None,
  SwissRound,
  RoundRobin,
  SingleElimination,
  DoubleElimination,
}

// todo 예약된 
// 'test MTGO'
