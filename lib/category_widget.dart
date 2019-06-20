import 'package:flutr_provider_theme_firesotre/states/category_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_category_dialog.dart';

class CategoryDropDown extends StatefulWidget {
  @override
  _CategoryDropDownState createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  @override
  Widget build(BuildContext context) {
    final categoryState = Provider.of<CategoryState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<CategoryState>(
                  builder: (context, categoryState, _) {
                    var categories = categoryState.allCategories;

                    if (categories == null) {
                      return Container();
                    } else if (categories.length == 0) {
                      return Container(child: Text('Create Your First List'));
                    } else {
                      _validateSelectedCategory(categoryState);

                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: categoryState.selected,
                          items: categoryState.allCategories.map((document) {
                            return DropdownMenuItem<String>(
                              value: document.documentID,
                              child: Text(
                                document.data['name'],
                                maxLines: 1,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            categoryState.selected = value;
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Visibility(
              visible: categoryState.allCategories != null &&
                  categoryState.allCategories.length > 0,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  var selectedCategory = categoryState.allCategories.firstWhere(
                      (category) =>
                          category.documentID == categoryState.selected);

                  showDialog<dynamic>(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (BuildContext context) {
                      return AddCategoryDialog(
                        categoryState: categoryState,
                        category: selectedCategory,
                      );
                    },
                  );
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                showDialog<dynamic>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    return AddCategoryDialog(categoryState: categoryState);
                  },
                );
              },
            )
          ],
        ),
        Divider(
          height: 1,
          color: Colors.grey[600],
        ),
      ],
    );
  }

  void _validateSelectedCategory(CategoryState categoryState) {
    List list = categoryState.allCategories.where(
      (document) {
        return document.documentID == categoryState.selected;
      },
    ).toList();

    //if selected category not found on the list, select first from the list
    if (list.length == 0) {
      categoryState.selected = categoryState.allCategories[0].documentID;
    }
  }
}
