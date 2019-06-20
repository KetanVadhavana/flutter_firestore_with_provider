import 'package:flutr_provider_theme_firesotre/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userName;
  String _password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    var auth = Provider.of<AuthenticationState>(context);

    return ChangeNotifierProvider<LoginState>(
      builder: (context) => LoginState(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Tasks'),
        ),
//        backgroundColor: Colors.grey[300],
        body: Consumer<LoginState>(
          builder: (context, state, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.lock),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Login",
                                    style: Theme.of(context).textTheme.headline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Divider(
                            height: 8,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            initialValue: 'ketan@gmail.com',
                            decoration: InputDecoration(
                                isDense: true,
                                icon: Icon(Icons.email),
                                hasFloatingPlaceholder: true,
                                labelText: 'Email'),
                            onSaved: (value) {
                              _userName = value;
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            initialValue: 'ketan123',
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock_outline),
                                isDense: true,
                                hasFloatingPlaceholder: true,
                                labelText: 'Password'),
                            obscureText: true,
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                          SizedBox(
                            height: 55,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  (state.currentState ==
                                          UserLoginState.LogInFail)
                                      ? state.loginMessage ?? ''
                                      : '',
                                  style: TextStyle(color: Colors.redAccent),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          RaisedButton(
                            onPressed:
                                state.currentState != UserLoginState.LoggingIn
                                    ? () => _onLogin(context)
                                    : null,
                            child: Text(
                                state.currentState == UserLoginState.LoggingIn
                                    ? 'Logging In...'
                                    : 'Login'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onLogin(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Provider.of<LoginState>(context)
          .sigIn(email: _userName, password: _password);
    }
  }
}
