import 'package:equatable/equatable.dart';

class StudentMdl extends Equatable {
  final String id;
  final String name;
  final String major;

  const StudentMdl({
    required this.id,
    required this.name,
    required this.major,
  });

  factory StudentMdl.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return StudentMdl(
      id: id,
      name: map['name'],
      major: map['major'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'major': major,
    };
  }

  @override
  List<Object?> get props => [id, name, major];
}
