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
      body: topicProvider.isLoading || createClassProvider.isLoading
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
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('¿Estás seguro de guardar?'),
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
                    ).then((value) {
                      if (value == true) {
                        createClassProvider.saveFormCreateClass().then((value) {
                          if (value) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Clase creada exitosamente'),
                                content: Text(
                                    'Código de la clase: ${createClassProvider.newClassCode}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.go('/home');
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Ocurrió un error al guardar la clase',
                                ),
                              ),
                            );
                          }
                        });
                      }
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ocurrió un error al guardar la clase',
                          ),
                        ),
                      );
                    });
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
                  onPressed: createClassProvider.currentStepIndex == 0
                      ? () => _validateStepCreateClass(createClassProvider)
                      : () => _validateStepAssignTopic(
                          createClassProvider, context),
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

  void _validateStepAssignTopic(
      CreateClassProvider createClassProvider, BuildContext context) {
    if (createClassProvider.hasAssignTopicRef()) {
      createClassProvider.nextStep();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, seleccione al menos un tema',
          ),
        ),
      );
    }
  }

  void _validateStepCreateClass(CreateClassProvider createClassProvider) {
    if (createClassProvider.validateCreateClass()) {
      createClassProvider.nextStep();
    }
  }
}

class _CreateClassView extends StatelessWidget {
  const _CreateClassView();

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
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
    );
  }
}

class _CreateClassResumen extends StatelessWidget {
  const _CreateClassResumen();

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();
    final topicProvider = context.watch<TopicProvider>();
    final assignedTopics = topicProvider
        .getTopicsByIds(createClassProvider.formCreateClass.topicsRefs);
    final form = createClassProvider.formCreateClass;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información general',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),

            // Title
            Text('Título: ${form.title}'),
            const SizedBox(height: 10),

            // Description
            Text('Descripción: ${form.description}'),
            const SizedBox(height: 35),

            // Assigned topics
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Temas asignados',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: assignedTopics.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${index + 1} ${assignedTopics[index].title}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormCreateClass extends StatelessWidget {
  const _FormCreateClass();

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();
    final form = createClassProvider.formCreateClass;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: createClassProvider.formKeyCreateClass,
        child: Column(
          children: [
            // Title
            TextFormField(
              maxLength: 50,
              initialValue: form.title,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title_rounded),
                labelText: 'Título',
              ),
              onSaved: (newValue) {
                form.title = newValue ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un título';
                }
                return null;
              },
            ),

            // Description
            TextFormField(
              maxLength: 150,
              initialValue: form.description,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description_rounded),
                labelText: 'Descripción',
              ),
              onSaved: (newValue) {
                form.description = newValue ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese una descripción';
                }
                return null;
              },
            ),
          ],
        ),
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
            value:
                createClassProvider.hasTopicRef(topicProvider.topics[index].id),
            onChanged: (newValue) {
              if (newValue == true) {
                //createClassProvider.addTopicId(topicProvider.topics[index].id);
                createClassProvider.addTopicRef(topicProvider.topics[index].id);
              } else {
                createClassProvider
                    .deleteTopicRef(topicProvider.topics[index].id);
              }
            },
          );
        },
      ),
    );
  }
}
