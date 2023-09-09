import 'package:e_quizzmath/presentation/providers/class_provider.dart';
import 'package:e_quizzmath/presentation/widgets/custom_circle_progress_indicator.dart';
import 'package:e_quizzmath/presentation/widgets/custom_not_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudiantes'),
      ),
      body: classProvider.isLoading
          ? const CustomCircleProgressIndicator()
          : (classProvider.students.isEmpty)
              ? const CustomNotContent(
                  message: 'No hay estudiantes en esta clase',
                )
              : const _CustomListStudents(),
    );
  }
}

class _CustomListStudents extends StatelessWidget {
  const _CustomListStudents();

  @override
  Widget build(BuildContext context) {
    final students = context.watch<ClassProvider>().students;

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.person_rounded),
          title: Text(students[index].fullName),
          subtitle: Text(students[index].email),
          onTap: () {},
        );
      },
    );
  }
}
