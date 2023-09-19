import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
import 'package:e_quizzmath/presentation/widgets/custom_not_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateTopicScreen extends StatelessWidget {
  const CreateTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();

    return Scaffold(
      appBar: AppBar(
        title:
            Text(topicProvider.topicSteps[topicProvider.currentSteps]['title']),
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('¿Estas seguro de salir?'),
                content: const Text('Si sales perderás los cambios realizados'),
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
            ).then((value) => {if (value == true) context.pop()});
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: topicProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : const _CreateTopicView(),
      floatingActionButton: const _CustomFloatingActionButton(),
    );
  }
}

class _CreateTopicView extends StatelessWidget {
  const _CreateTopicView();

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Progress
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: (topicProvider.currentSteps + 1) /
                            topicProvider.numSteps,
                        minHeight: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              // Description
              const Text(
                'Al finalizar este proceso podrás seleccionar este tema cuando crees una clase.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Forms
        [
          _FormCreateTopic(),
          const _ListAssignedUnit(),
          const _CreateTopicResumen(),
        ][topicProvider.currentSteps],
      ],
    );
  }
}

class _CreateTopicResumen extends StatelessWidget {
  const _CreateTopicResumen();

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();
    final formTopic = topicProvider.formCreateTopic;
    final formUnits = topicProvider.units;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tema',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Text('Título: ${formTopic.title}'),
            const SizedBox(height: 10),
            Text('Descripción: ${formTopic.description}'),
            const SizedBox(height: 35),
            const Text(
              'Unidades',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),
            Expanded(
              child: formUnits.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: formUnits.length,
                      itemBuilder: (context, index) {
                        final unit = formUnits[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Título: ${unit.title}'),
                            const SizedBox(height: 10),
                            Text('Descripción: ${unit.description}'),
                            const SizedBox(height: 10),
                            Text('Videos: ${unit.playlist.length}'),
                            const SizedBox(height: 10),
                            const Divider(),
                          ],
                        );
                      },
                    )
                  : const CustomNotContent(message: 'No hay unidades creadas'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomFloatingActionButton extends StatelessWidget {
  const _CustomFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Save
        Visibility(
          visible: [topicProvider.numSteps - 1]
                  .contains(topicProvider.currentSteps) &&
              topicProvider.units.isNotEmpty,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'save',
                onPressed: () {
                  //topicProvider.saveFormCreateTopic();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('¿Estas seguro de guardar?'),
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
                      topicProvider.saveFormCreateTopic().then((value) {
                        if (value) {
                          /* ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tema creado exitosamente'),
                            ),
                          ); */
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Tema creado exitosamente'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.go('/home');
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Ocurrió un error al crear el tema'),
                            ),
                          );
                        }
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ocurrió un error al crear el tema'),
                          ),
                        );
                      });
                    }
                  });
                },
                child: const Icon(Icons.save),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // Add unit
        Visibility(
          visible: [1].contains(topicProvider.currentSteps),
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'add',
                onPressed: () {
                  context.push('/class/topic/create-unit');
                },
                child: const Icon(Icons.add_rounded),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // Back
        Visibility(
          visible: [1, 2].contains(topicProvider.currentSteps),
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'back',
                onPressed: topicProvider.isLoading
                    ? null
                    : () => topicProvider.previousStep(),
                child: const Icon(Icons.arrow_back_ios_rounded),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),

        // Next
        Visibility(
          visible: [0, 1].contains(topicProvider.currentSteps),
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'next',
                onPressed: () {
                  if (topicProvider.currentSteps == 0) {
                    topicProvider.validateFormCreateTopic();
                    return;
                  }

                  if (topicProvider.currentSteps == 1) {
                    if (topicProvider.units.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, crea las unidades'),
                        ),
                      );
                      return;
                    }
                  }

                  topicProvider.nextStep();
                },
                child: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class _ListAssignedUnit extends StatelessWidget {
  const _ListAssignedUnit();

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();

    return topicProvider.units.isEmpty
        ? const CustomNotContent(message: 'No hay unidades creadas')
        : Expanded(
            child: ListView.builder(
              itemCount: topicProvider.units.length,
              itemBuilder: (context, index) {
                final unit = topicProvider.units[index];
                return ListTile(
                  title: Text(unit.title),
                  subtitle: Text(unit.description),
                  leading: IconButton(
                    onPressed: () {
                      topicProvider.deleteUnit(index);
                    },
                    icon: const Icon(Icons.delete_rounded),
                  ),
                  onTap: () {},
                );
              },
            ),
          );
  }
}

class _FormCreateTopic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();

    return Form(
      key: topicProvider.formKeyCreateTopic,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Title
            TextFormField(
              initialValue: topicProvider.formCreateTopic.title,
              maxLength: 50,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title_rounded),
                labelText: 'Título',
              ),
              onChanged: (newValue) {
                topicProvider.formCreateTopic.title = newValue;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'El título es requerido';
                }

                return null;
              },
            ),

            // Description
            TextFormField(
              maxLength: 150,
              initialValue: topicProvider.formCreateTopic.description,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description_rounded),
                labelText: 'Descripción',
              ),
              onChanged: (newValue) {
                topicProvider.formCreateTopic.description = newValue;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'La descripción es requerida';
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
