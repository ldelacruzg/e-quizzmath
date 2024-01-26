import 'package:e_quizzmath/presentation/providers/class_provider.dart';
import 'package:e_quizzmath/presentation/providers/create_class_provider.dart';
import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
import 'package:e_quizzmath/presentation/providers/user_logged_in_provider.dart';
import 'package:e_quizzmath/presentation/widgets/custom_circle_progress_indicator.dart';
import 'package:e_quizzmath/presentation/widgets/custom_not_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  String getMessageNotContent(BuildContext context) {
    final userLoggedInProvider = context.read<UserLoggedInProvider>();

    switch (userLoggedInProvider.userLogged.type) {
      case 'teacher':
        return 'No hay clases creadas';
      case 'student':
        return 'No hay clases a las que te hayas unido';
      default:
        return 'Contacte con soporte';
    }
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    final userLoggedInProvider = context.watch<UserLoggedInProvider>();
    final createClassProvider = context.watch<CreateClassProvider>();
    final topicProvider = context.watch<TopicProvider>();

    if (userLoggedInProvider.userLogged.type == 'teacher') {
      return FloatingActionButton(
        onPressed: () {
          createClassProvider.reset();
          topicProvider.loadTopics();
          context.push('/create-class');
        },
        child: const Icon(Icons.add),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis clases'),
      ),
      body: classProvider.isLoading
          ? const CustomCircleProgressIndicator()
          : (classProvider.classes.isEmpty)
              ? CustomNotContent(message: getMessageNotContent(context))
              : const _CustomListClasses(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }
}

class _CustomListClasses extends StatelessWidget {
  const _CustomListClasses();

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();
    final topicProvider = context.watch<TopicProvider>();

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
            itemBuilder: (context) => <PopupMenuEntry<String>>[
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
                  topicProvider
                      .loadTopicsByClass(classProvider.classes[index].id);
                  context.push('/class/topics');
                },
              ),
              /* PopupMenuItem(
                child: const Text('Clasificación'),
                onTap: () {
                  //classProvider.loadStudentsByClass(index);
                  context.push('/class/leaderboard');
                },
              ), */
              const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text('Copiar código'),
                onTap: () {
                  // copiar código en portapapeles
                  Clipboard.setData(
                    ClipboardData(
                        text:
                            '''Nombre de la clase: ${classProvider.classes[index].title}\nCódigo de la clase: ${classProvider.classes[index].code}'''),
                  ).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Código copiado en portapapeles'),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
