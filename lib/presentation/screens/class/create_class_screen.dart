import 'package:e_quizzmath/presentation/providers/create_class_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateClassScreen extends StatelessWidget {
  const CreateClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear clase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Progress
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: (createClassProvider.currentStepIndex + 1) /
                            createClassProvider.numSteps,
                        minHeight: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              // Title
              Text(
                createClassProvider.currentStep['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),

              // Description
              const Text(
                'Al finalizar este proceso se le generará un código de la clase para que lo compartas con sus estudiantes y puedan ver el contenido.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),

              // Forms
              [
                const _FormCreateClass(),
                const _ListAssignedTopics(),
              ][createClassProvider.currentStepIndex],
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add button
          Visibility(
            visible: [1, 2].contains(createClassProvider.currentStepIndex),
            child: FloatingActionButton(
              heroTag: const Key('add_button'),
              onPressed: () {
                if (createClassProvider.currentStepIndex == 1) {
                  context.push('/class/create-topic');
                }
              },
              child: const Icon(Icons.add_rounded),
            ),
          ),
          const SizedBox(height: 10),

          // Next button
          Visibility(
            visible: [0, 1, 2].contains(createClassProvider.currentStepIndex),
            child: FloatingActionButton(
              heroTag: const Key('next_button'),
              onPressed: () {
                createClassProvider.nextStep();
              },
              child: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
          const SizedBox(height: 10),

          // Back button
          Visibility(
            visible: [1, 2].contains(createClassProvider.currentStepIndex),
            child: FloatingActionButton(
              heroTag: const Key('back_button'),
              onPressed: () {
                createClassProvider.previousStep();
              },
              child: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCreateClass extends StatelessWidget {
  const _FormCreateClass();

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();
    final formKey = GlobalKey<FormState>();
    final formClass = createClassProvider.formClass;

    return Form(
      key: formKey,
      child: Column(
        children: [
          // Title
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.title_rounded),
              labelText: 'Título',
            ),
            onSaved: (newValue) {
              formClass.title = newValue ?? '';
            },
          ),
          const SizedBox(height: 20),

          // Description
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.description_rounded),
              labelText: 'Descripción',
            ),
            onSaved: (newValue) {
              formClass.description = newValue ?? '';
            },
          ),
        ],
      ),
    );
  }
}

class _ListAssignedTopics extends StatelessWidget {
  const _ListAssignedTopics();

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();

    return createClassProvider.assignedTopics.isEmpty
        ? const Text('No hay temas asignados')
        : ListView.builder(
            shrinkWrap: true,
            itemCount: createClassProvider.assignedTopics.length,
            itemBuilder: (context, index) {
              final topic = createClassProvider.assignedTopics[index];

              return ListTile(
                title: Text(topic.title),
                subtitle: Text(topic.description),
                leading: const Icon(Icons.topic_rounded),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Eliminar'),
                      onTap: () {
                        createClassProvider.deleteTopic(index);
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Asignar unidades'),
                      onTap: () {},
                    ),
                  ],
                ),
                onTap: () => {},
              );
            },
          );
  }
}
