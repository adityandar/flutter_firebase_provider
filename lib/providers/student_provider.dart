import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/student_mdl.dart';

class StudentProvider extends ChangeNotifier {
  final _students = <StudentMdl>[];
  var _isLoading = false;

  List<StudentMdl> get students => _students;
  bool get isLoading => _isLoading;

  final CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection('students');

  Future<void> onBuild() async {
    fetchData();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    final response = await _studentCollection.get();
    final datas = response.docs;

    _students.clear();
    for (final data in datas) {
      final jsonMap = data.data() as Map<String, dynamic>?;
      if (jsonMap != null) {
        students.add(
          StudentMdl.fromMap(
            id: data.id,
            map: jsonMap,
          ),
        );
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addData({required StudentMdl student}) async {
    // add data to firebase
    _loadingAndNotifyListenerWrapper(
      () async => await _studentCollection.add(
        student.toMap(),
      ),
    );

    // use this to add manually to list.
    // _students.add(student);
    // notifyListeners();
  }

  Future<void> updateData({
    required StudentMdl student,
  }) async {
    _loadingAndNotifyListenerWrapper(
      () async => await _studentCollection.doc(student.id).update(
            student.toMap(),
          ),
    );
    fetchData();

    // use this to update manually the list.
    // final index = _students.indexWhere(
    //   (eachStudent) => eachStudent.id == student.id,
    // );
    // _students[index] = student;
    // notifyListeners();
  }

  Future<void> deleteData({required String id}) async {
    _loadingAndNotifyListenerWrapper(
      () async => await _studentCollection.doc(id).delete(),
    );
    // use this to manually remove from list.
    // _students.removeWhere((student) => student.id == id);
    // notifyListeners();
  }

  Future<void> _loadingAndNotifyListenerWrapper(AsyncCallback callback) async {
    _isLoading = true;
    notifyListeners();
    await callback.call();
    _isLoading = false;
    notifyListeners();
    fetchData();
  }
}
