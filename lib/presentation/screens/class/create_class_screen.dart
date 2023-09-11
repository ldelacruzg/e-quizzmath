import 'package:e_quizzmath/presentation/providers/create_class_provider.dart';
import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateClassScreen extends StatelessWidget {
  const CreateClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();
    final topicProvider = context.watch<TopicProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(createClassProvider.currentStep['title']),
        leading: IconButton(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Estás seguro de salir?'),
                content: const Text('Si sales perderás todo el progreso.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop(true);
                    },
                    child: const Text('Si'),
                  ),
                ],
              ),
            ).then((value) => value == true ? context.pop() : null);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: topicProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : const _CreateClassView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add button
          Visibility(
            visible: [2].contains(createClassProvider.currentStepIndex),
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: const Key('add_button'),
                  onPressed: () {
                    if (createClassProvider.currentStepIndex == 1) {
                      context.push('/class/create-topic');
                    }
                  },
                  child: const Icon(Icons.save_rounded),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Back button
          Visibility(
            visible: [1, 2].contains(createClassProvider.currentStepIndex),
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: const Key('back_button'),
                  onPressed: () {
                    createClassProvider.previousStep();
                  },
                  child: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Next button
          Visibility(
            visible: [0, 1].contains(createClassProvider.currentStepIndex),
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: const Key('next_button'),
                  onPressed: () {
                    createClassProvider.nextStep();
                  },
                  child: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateClassView extends StatelessWidget {
  const _CreateClassView();

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Visibility(
            visible: true,
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

                // Description
                const Text(
                  'Al finalizar este proceso se le generará un código de la clase para que lo compartas con sus estudiantes y puedan ver el contenido.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),

          // Forms
          [
            const _FormCreateClass(),
            const _ListAssignedTopics(),
            const _CreateClassResumen(),
          ][createClassProvider.currentStepIndex],
        ],
      ),
    );
  }
}

class _CreateClassResumen extends StatelessWidget {
  const _CreateClassResumen();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
    final topicProvider = context.watch<TopicProvider>();
    final createClassProvider = context.watch<CreateClassProvider>();

    return Expanded(
      child: ListView.builder(
        itemCount: topicProvider.topics.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(topicProvider.topics[index].title),
            subtitle: Text(topicProvider.topics[index].description),
            value: createClassProvider.assignedTopicsIds
                .contains(topicProvider.topics[index].id),
            onChanged: (newValue) {
              if (newValue == true) {
                createClassProvider.addTopicId(topicProvider.topics[index].id);
              } else {
                createClassProvider
                    .deleteTopicId(topicProvider.topics[index].id);
              }
            },
          );
        },
      ),
    );
  }
}
