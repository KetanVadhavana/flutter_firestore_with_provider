import 'package:flutr_provider_theme_firesotre/states/auth_state.dart';
import 'package:flutr_provider_theme_firesotre/states/shared_preference_state.dart';
import 'package:flutr_provider_theme_firesotre/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'login_screen.dart';
import 'states/auth_state.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SharedPreferenceState>(
      builder: (context) => SharedPreferenceState(),
      child: Consumer<SharedPreferenceState>(
        builder: (context, state, _) {
          if (state.preferences == null) {
            return Container(
              color: Colors.white,
              child: Center(
                child: Icon(
                  Icons.format_list_bulleted,
                  textDirection: TextDirection.ltr,
                  size: 55,
                  color: Colors.grey[800],
                ),
              ),
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                  value: ThemeState(state.preferences)),
              ChangeNotifierProvider.value(value: AuthenticationState()),
            ],
            child: Consumer<ThemeState>(
              builder: (context, state, _) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme: state.appTheme,
                  home: Consumer<AuthenticationState>(
                      builder: (context, authState, _) {
                    if (authState.state == AuthState.UnAuthenticated) {
                      return LoginPage();
                    } else if (authState.state == AuthState.Authenticated) {
                      return MyHomePage();
                    } else if (authState.state == AuthState.NotInitialized) {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Icon(
                            Icons.format_list_bulleted,
                            textDirection: TextDirection.ltr,
                            size: 55,
                            color: Colors.grey[800],
                          ),
                        ),
                      );
                    }
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
