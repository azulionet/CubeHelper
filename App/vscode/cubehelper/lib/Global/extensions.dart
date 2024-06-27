import 'define.dart';
import '../Function/optionManager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

extension String_ExtensionMethos on String {
  int toInt() {
    return int.parse(this);
  }

  void toast() {
    Fluttertoast.showToast(
        msg: this,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void toastMiddle() {
    Fluttertoast.showToast(
        msg: this,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 24.0);
  }

  void toastBig() {
    Fluttertoast.showToast(
        msg: this,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 36.0);
  }

  bool isNullOrEmpty() {
    return isEmpty;
  }

  void sendEmail(String emailBody) async {
    final Email email = Email(
      body: emailBody,
      subject: this,
      recipients: ['duqrlehs@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ("email 보낼 때 에러 났습니다. ㅠㅠ. duqrlehs@gmail.com 으로 직접 보내주세요 ㅠㅠ\n 에러 : $error")
          .toast();
    }
  }

  bool isValidEmail() {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(this);
  }

  // db에 넣을 수 있는 형태의 문자열로 치환
  String createFirebaseKeyFromEmail() {
    if (isValidEmail() == false) {
      return "";
    }

    const forbiddenChars = ['.', '#', '\$', '[', ']'];

    String safeId = this;
    for (var char in forbiddenChars) {
      safeId = safeId.replaceAll(RegExp('\\$char'), ',');
    }

    return safeId;
  }

  int getFirebaseDBKeyNumber() {
    // , 로 검색함 키의 경우 .을 db에 넣을 수 없어서 ,로 치환한 후에 저장함
    //  createFirebaseKeyFromEmail() 참고
    if (contains("@google,com") == false) {
      return -1;
    }

    String number = "";
    RegExp exp = RegExp(r".com(\d{1,3})");
    var match = exp.firstMatch(this);

    if (match != null) {
      number = match.group(1)!; // group(1)은 첫 번째 괄호로 묶인 그룹을 나타냅니다.
    }

    if (number.isEmpty == true) {
      return -1;
    }

    return int.parse(number);
  }
}

extension EOption_ExtensionMethods on EOption {
  bool? isTrue() {
    String? s = OptionManager.get(this);

    if (s == null) {
      return null;
    }

    return s == "true";
  }

  String? getValue() {
    return OptionManager.get(this);
  }

  void setOptionValue(String aSvalue) {
    OptionManager.setOptionValue(this, aSvalue);
  }

  void removeOption() {
    OptionManager.removeOption(this);
  }
}
