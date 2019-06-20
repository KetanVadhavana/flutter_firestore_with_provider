import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'category_state.dart';

class TaskState extends ChangeNotifier {
  List<DocumentSnapshot> allTasks;

  CategoryState category;

  StreamSubscription<String> subscription;

  TaskState({@required this.category}) {
    subscription = category.selectedCategory.listen((selectedCategory) {
      _fetchTask(selectedCategory);
    });
  }

  void _fetchTask(String selectedCategory) {
    print('[Selected Category] -> $selectedCategory');

    if (selectedCategory == null ||
        selectedCategory.isEmpty ||
        selectedCategory == '0') {
      allTasks = [];
      notifyListeners();
      return;
    }

    Firestore.instance
        .collection('tasks')
        .where('category', isEqualTo: selectedCategory)
        .orderBy('created_on', descending: true)
        .snapshots()
        .listen((snapshot) {
      allTasks = snapshot.documents.toList();

      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  void markComplete(String taskId, bool completed) {
    Firestore.instance
        .collection('tasks')
        .document(taskId)
        .updateData({'completed': completed});
  }

  void updateTask({String taskId, String description}) {
    Firestore.instance
        .collection('tasks')
        .document(taskId)
        .updateData({'description': description});
  }

  void deleteTask({taskId}) {
    Firestore.instance.collection('tasks').document(taskId).delete();
  }

  void addTask(String description, String selectedCategory) {
//    DocumentReference reference =
//        Firestore.instance.collection('categories').document(selectedCategory);
//
//    reference.snapshots().listen((document) {
//      print('~~~~~~~~~~~~~~~${document.data}');
//    });

    Map<String, dynamic> data = {
      'description': description,
      'category': selectedCategory,
      'completed': false,
      'created_on': FieldValue.serverTimestamp(),
    };

//    DocumentReference reference =
//        Firestore.instance.collection('tasks').document();
//    print('~~~~~~~~~~~~~~New Task await: ${reference.documentID}');
//    reference.setData(data);

    Firestore.instance.collection('tasks').add(data);
  }
}
