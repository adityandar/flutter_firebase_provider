// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/student_mdl.dart';
import 'package:flutter_firebase/providers/student_provider.dart';

enum ActionType { create, update }

extension ActionTypeExtension on ActionType {
  bool get isCreate => this == ActionType.create;
  bool get isUpdate => this == ActionType.update;
}

class StudentOperationBottomSheet extends StatefulWidget {
  const StudentOperationBottomSheet({
    super.key,
    required this.action,
    required this.provider,
    this.student,
  });

  final ActionType action;
  final StudentMdl? student;
  final StudentProvider provider;

  static Future<void> show(
    BuildContext context, {
    required StudentProvider provider,
    StudentMdl? student,
  }) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return StudentOperationBottomSheet(
          action: student != null ? ActionType.update : ActionType.create,
          provider: provider,
          student: student,
        );
      },
    );
  }

  @override
  State<StudentOperationBottomSheet> createState() =>
      _StudentOperationBottomSheetState();
}

class _StudentOperationBottomSheetState
    extends State<StudentOperationBottomSheet> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _majorController = TextEditingController();

  StudentMdl? get student => widget.student;
  StudentProvider get provider => widget.provider;

  String get name => _nameController.text;
  String get major => _majorController.text;

  @override
  void initState() {
    super.initState();

    if (student != null) {
      _nameController.text = student!.name;
      _majorController.text = student!.major;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
            child: Text(widget.action.isCreate ? 'Create' : 'Update'),
            onPressed: () {
              final newStudent = StudentMdl(
                id: widget.student?.id ?? '',
                name: name,
                major: major,
              );
              if (widget.action.isCreate) {
                provider.addData(student: newStudent);
              } else {
                provider.updateData(student: newStudent);
              }

              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
