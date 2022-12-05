import 'package:flutter/material.dart';

// ChangeNotifier 상속 받이 상태 관리
// 이 안에 있는 맴버 변수 값들을 상태 관리 한다.
class MatlabProvider extends ChangeNotifier {
  TextEditingController matlabText = TextEditingController();
  TextEditingController convertTextController = TextEditingController();

  setMatlabText(String code) {
    matlabText.text = code;
    notifyListeners();
  }

  setConvertText(String code) {
    convertTextController.text = code;
    notifyListeners();
  }

  update() {
    notifyListeners();
  }
}
