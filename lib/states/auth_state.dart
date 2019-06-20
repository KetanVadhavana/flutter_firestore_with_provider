import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState { NotInitialized, Authenticated, UnAuthenticated }

class AuthenticationState extends ChangeNotifier {
  AuthState _state = AuthState.NotInitialized;

  StreamSubscription<FirebaseUser> subscription;

  AuthState get state => _state;

  AuthenticationState() {
    FirebaseAuth.instance.currentUser().then((user) {
      _state =
          (user != null) ? AuthState.Authenticated : AuthState.UnAuthenticated;
    });

    subscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      print(user);

      if (user != null) {
        _state = AuthState.Authenticated;
      } else {
        _state = AuthState.UnAuthenticated;
      }

      notifyListeners();
    });
  }

  void signOut() async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();

    FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    super.dispose();

    subscription.cancel();
  }
}
