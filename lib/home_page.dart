import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/student_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();

  final CollectionReference _students =
      FirebaseFirestore.instance.collection('students');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _majorController.text = documentSnapshot['major'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _majorController,
                  decoration: const InputDecoration(labelText: 'Major'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String major = _majorController.text;
                    if (action == 'create') {
                      await _students.add({"name": name, "major": major});
                    }

                    if (action == 'update') {
                      await _students
                          .doc(documentSnapshot!.id)
                          .update({"name": name, "major": major});
                    }

                    _nameController.text = '';
                    _majorController.text = '';

                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _students.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully deleted a student'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentProvider>(
      create: (context) => StudentProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter x Firebase'),
        ),
        body: Consumer<StudentProvider>(
          builder: (context, studentProvider, child) {
            if (studentProvider.isLoading) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            final students = studentProvider.students;

            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Text(student.major),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createOrUpdate(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
