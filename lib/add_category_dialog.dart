import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutr_provider_theme_firesotre/states/category_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final CategoryState categoryState;
  final DocumentSnapshot category;

  AddCategoryDialog({@required this.categoryState, this.category});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  String _categoryName;
  final _formKey = GlobalKey<FormState>();

  bool get isEdit => widget.category != null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Container(
        child: Form(
          key: _formKey,
          child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            initialValue: isEdit ? widget.category.data['name'] : '',
            decoration: InputDecoration(
              labelText: 'Category Name',
              alignLabelWithHint: true,
            ),

            validator: (value) {
              if (value.isEmpty) {
                return 'Enter category name';
              }

              return null;
            },
            onSaved: (value) {
              _categoryName = value;
            },
          ),
        ),
      ),
      actions: <Widget>[
        isEdit
            ? FlatButton.icon(
                onPressed: () {
                  widget.categoryState.deleteCategory(
                    categoryId: widget.category.documentID,
                  );
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
                widget.categoryState.updateCategory(
                    categoryId: widget.category.documentID,
                    categoryName: _categoryName);
              } else {
                widget.categoryState.addCategory(_categoryName);
              }

              Navigator.pop(context, _categoryName);
            }
          },
          child: Text(isEdit ? 'Update' : 'Create'),
        )
      ],
    );
  }
}
