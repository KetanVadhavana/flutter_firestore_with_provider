import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceState with ChangeNotifier {
  SharedPreferences preferences;

  SharedPreferenceState() {
    load();
  }

  Future load() async {
    preferences = await SharedPreferences.getInstance();
    notifyListeners();
  }
}
