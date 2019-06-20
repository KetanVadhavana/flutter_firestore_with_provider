import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'auth_state.dart';

enum UserLoginState { LogInSuccess, LogInFail, NotLoggedIn, LoggingIn }

class LoginState with ChangeNotifier {
  UserLoginState _state = UserLoginState.NotLoggedIn;

  String _loginMessage;

  UserLoginState get currentState => _state;

  AuthenticationState authState;

  String get loginMessage => _loginMessage;

  LoginState({this.authState});

  void sigIn({String email, String password}) async {
    _state = UserLoginState.LoggingIn;
    notifyListeners();

    try {
      FirebaseUser user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (user != null) {
        _state = UserLoginState.LogInSuccess;
      }
    } on PlatformException catch (e) {
      _state = UserLoginState.LogInFail;

      _loginMessage = e.message;
      print(e.toString());
    }

    notifyListeners();
  }
}
