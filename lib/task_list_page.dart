import 'package:flutr_provider_theme_firesotre/states/task_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_task_dialog.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Consumer<TaskState>(
        builder: (context, state, _) {
          print('Loaded Tasks [${(state.allTasks ?? []).length}]');

          if (state.allTasks == null) {
            //Categories are not loaded
            return Center(child: CircularProgressIndicator());
          } else if (state.allTasks.length == 0) {
            //Categories are loaded but empty list
            return Center(child: Text('No Tasks'));
          }

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  height: 1,
                ),
            itemCount: state.allTasks.length,
            itemBuilder: (context, index) {
              final task = state.allTasks[index];

              return ListTile(
                dense: true,
                key: UniqueKey(),
                onTap: () {
                  showDialog<dynamic>(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (BuildContext context) {
                      return AddTaskDialog(
                        taskState: state,
                        task: state.allTasks[index],
                      );
                    },
                  );
                },
                leading: Checkbox(
                  value: task.data['completed'],
                  onChanged: (val) {
                    state.markComplete(task.documentID, val);
                  },
                ),
                title: Text(
                  task.data['description'],
                  style: TextStyle(fontSize: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
