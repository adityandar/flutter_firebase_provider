import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/student_mdl.dart';
import 'package:flutter_firebase/providers/student_provider.dart';
import 'package:flutter_firebase/widgets/student_operation_bottom_sheet.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final provider = StudentProvider();

  @override
  void initState() {
    super.initState();
    provider.onBuild();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter x Firebase'),
        ),
        body: Consumer<StudentProvider>(
          builder: (context, provider, child) {
            final students = provider.students;
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                return StudentCard(student: student);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => StudentOperationBottomSheet.show(
            context,
            provider: provider,
          ),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  const StudentCard({
    Key? key,
    required this.student,
  }) : super(key: key);

  final StudentMdl student;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(student.name),
        subtitle: Text(student.major),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => StudentOperationBottomSheet.show(
                  context,
                  student: student,
                  provider: provider,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => provider.deleteData(id: student.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
