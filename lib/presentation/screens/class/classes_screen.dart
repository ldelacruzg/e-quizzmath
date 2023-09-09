import 'package:e_quizzmath/presentation/providers/class_provider.dart';
import 'package:e_quizzmath/presentation/providers/create_class_provider.dart';
import 'package:e_quizzmath/presentation/widgets/custom_circle_progress_indicator.dart';
import 'package:e_quizzmath/presentation/widgets/custom_not_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();
    final createClassProvider = context.watch<CreateClassProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis clases'),
      ),
      body: classProvider.isLoading
          ? const CustomCircleProgressIndicator()
          : (classProvider.classes.isEmpty)
              ? const CustomNotContent()
              : const _CustomListClasses(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createClassProvider.reset();
          context.push('/create-class');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CustomListClasses extends StatelessWidget {
  const _CustomListClasses();

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();

    return ListView.builder(
      itemCount: classProvider.classes.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.class_rounded),
          title: Text(
            classProvider.classes[index].title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Código: ${classProvider.classes[index].code}'),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Estudiantes'),
                onTap: () {
                  classProvider.loadStudentsByClass(index);
                  context.push('/class/students');
                },
              ),
              PopupMenuItem(
                child: const Text('Temas'),
                onTap: () {
                  classProvider.loadStudentsByClass(index);
                  context.push('/class/students');
                },
              ),
              PopupMenuItem(
                child: const Text('Clasificación'),
                onTap: () {
                  classProvider.loadStudentsByClass(index);
                  context.push('/class/students');
                },
              ),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }
}
