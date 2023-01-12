import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/student_mdl.dart';

class StudentProvider extends ChangeNotifier {
  final _students = <StudentMdl>[];
  bool _isLoading = false;

  List<StudentMdl> get students => _students;
  bool get isLoading => _isLoading;

  final CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection('students');

  StudentProvider() {
    fetchStudents();
  }

  Future<void> fetchStudents() async {
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
}
