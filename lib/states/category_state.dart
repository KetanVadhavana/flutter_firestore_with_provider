import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _SAVED_CATEGORY = 'SAVED_CATEGORY';

class CategoryState extends ChangeNotifier {
  List<DocumentSnapshot> allCategories;
  String _selectedValue = '0';

  String get selected => _selectedValue ?? '0';

  StreamController<String> selCategoryController = StreamController<String>();

  Stream<String> get selectedCategory => selCategoryController.stream;

  set selected(String value) {
    _selectedValue = value;

    //Send selected category Id to stream to be listen by task list.
    selCategoryController.sink.add(value);

    notifyListeners();
    _savePreference(value);
  }

  ///Save current category selection to preference
  void _savePreference(value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(_SAVED_CATEGORY, value);
  }

  CategoryState() {
    //Read default category from shared preference
    _readPreference();

    //fetch categories from firestore
    loadCategories();
  }

  ///Read default value from preference
  void _readPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    selected = preferences.getString(_SAVED_CATEGORY);
  }

  void updateCategory({String categoryId, String categoryName}) {
    Firestore.instance
        .collection('categories')
        .document(categoryId)
        .updateData({'name': categoryName});
  }

  void addCategory(String category) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('categories').add({
      'name': category,
      'users': [user.uid]
    }).then((document) {
      //set the newly created category as default
      selected = document.documentID;
    });
  }

  void deleteCategory({categoryId}) {
    Firestore.instance.collection('categories').document(categoryId).delete();

    var tasks = Firestore.instance
        .collection('tasks')
        .where('category', isEqualTo: categoryId)
        .getDocuments();

    final batch = Firestore.instance.batch();

    tasks.then((query) {
      query.documents.forEach((task) => batch.delete(task.reference));
      batch.commit();
    });

    if (allCategories.length > 0) {
      //set the first category from the list as default
      selected = allCategories[0].documentID;
    }
  }

  @override
  void dispose() {
    super.dispose();

    selCategoryController.close();
  }

  /// fetches categories from firestore
  Future loadCategories() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection('categories')
        .where('users', arrayContains: user.uid)
        .snapshots()
        .listen((snapshot) {
      allCategories = snapshot.documents.toList();
      notifyListeners();
    });
  }
}
