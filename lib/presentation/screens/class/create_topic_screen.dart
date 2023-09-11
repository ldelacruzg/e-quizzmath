import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
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
            Text(topicProvider.currentSteps == 1 ? 'Crear tema' : 'Unidades'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: [
          _FormCreateTopic(),
          const _ListAssignedUnit(),
        ][topicProvider.currentSteps - 1],
      ),
      floatingActionButton: const _CustomFloatingActionButton(),
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
          visible:
              topicProvider.currentSteps == 2 && topicProvider.units.isNotEmpty,
          child: FloatingActionButton(
            heroTag: 'save',
            onPressed: () {},
            child: const Icon(Icons.save),
          ),
        ),
        const SizedBox(height: 10),

        // Add unit
        Visibility(
          visible: topicProvider.currentSteps == 2,
          child: FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              context.push('/class/topic/create-unit');
            },
            child: const Icon(Icons.add_rounded),
          ),
        ),
        const SizedBox(height: 10),

        // Back
        Visibility(
          visible: topicProvider.currentSteps == 2,
          child: FloatingActionButton(
            heroTag: 'back',
            onPressed: () {
              topicProvider.previousStep();
            },
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
        ),
        const SizedBox(height: 10),

        // Next
        Visibility(
          visible: topicProvider.currentSteps == 1,
          child: FloatingActionButton(
            heroTag: 'next',
            onPressed: () {
              topicProvider.nextStep();
            },
            child: const Icon(Icons.arrow_forward_ios_rounded),
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
        ? const Center(
            child: Text('No hay unidades asignadas'),
          )
        : ListView.builder(
            itemCount: topicProvider.units.length,
            itemBuilder: (context, index) {
              final unit = topicProvider.units[index];
              return ListTile(
                title: Text(unit.title),
                subtitle: Text(unit.description),
              );
            },
          );
  }
}

class _FormCreateTopic extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _FormCreateTopic();

  @override
  Widget build(BuildContext context) {
    //final Topic formTopic;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Title
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.title_rounded),
              labelText: 'Título',
            ),
            onSaved: (newValue) {
              //formTopic.title = newValue ?? '';
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
              //formTopic.description = newValue ?? '';
            },
          ),
        ],
      ),
    );
  }
}
