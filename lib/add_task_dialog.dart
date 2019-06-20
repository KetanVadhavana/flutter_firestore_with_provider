import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutr_provider_theme_firesotre/states/task_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final TaskState taskState;
  final DocumentSnapshot task;

  AddTaskDialog({@required this.taskState, this.task});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String _description;
  final _formKey = GlobalKey<FormState>();

  bool get isEdit => widget.task != null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Updat Task' : 'Add Task'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Container(
        child: Form(
          key: _formKey,
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            initialValue: isEdit ? widget.task.data['description'] : '',
            decoration: InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter task description';
              }

              return null;
            },
            onSaved: (value) {
              _description = value;
            },
          ),
        ),
      ),
      actions: <Widget>[
        isEdit
            ? FlatButton.icon(
                onPressed: () {
                  widget.taskState.deleteTask(taskId: widget.task.documentID);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.redAccent,
                ),
                label: Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              )
            : Container(),
        SizedBox(width: 10),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              if (isEdit) {
                widget.taskState.updateTask(
                    description: _description, taskId: widget.task.documentID);
              } else {
                String selectedCategory = widget.taskState.category.selected;

                widget.taskState.addTask(_description, selectedCategory);
              }

              Navigator.pop(context);
            }
          },
          child: Text(isEdit ? 'Update' : 'Create'),
        )
      ],
    );
  }
}
