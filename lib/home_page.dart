import 'package:flutr_provider_theme_firesotre/category_widget.dart';
import 'package:flutr_provider_theme_firesotre/states/auth_state.dart';
import 'package:flutr_provider_theme_firesotre/states/category_state.dart';
import 'package:flutr_provider_theme_firesotre/states/task_state.dart';
import 'package:flutr_provider_theme_firesotre/states/theme_state.dart';
import 'package:flutr_provider_theme_firesotre/task_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_task_dialog.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CategoryState categoryState;

  @override
  void initState() {
    super.initState();

    categoryState = CategoryState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: categoryState),
        ChangeNotifierProvider<TaskState>(
            builder: (context) => TaskState(category: categoryState)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tasks'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.lock),
                onPressed: () {
                  Provider.of<AuthenticationState>(context).signOut();
                }),
            IconButton(
                icon: Icon(Icons.swap_horizontal_circle),
                onPressed: () {
                  var theme = Provider.of<ThemeState>(context);

                  theme.setTheme = !theme.isDark;
                })
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CategoryDropDown(),
            TaskListPage(),
          ],
        ),
        floatingActionButton: Consumer<TaskState>(
          builder: (context, state, _) {
            return FloatingActionButton(
              onPressed: () {
                var taskState = Provider.of<TaskState>(context);

                showDialog<dynamic>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    return AddTaskDialog(taskState: taskState);
                  },
                );
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
