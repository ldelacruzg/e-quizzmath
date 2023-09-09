import 'package:e_quizzmath/presentation/providers/create_class_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateTopicScreen extends StatelessWidget {
  CreateTopicScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Topic formTopic = Topic(title: '', description: '');

  @override
  Widget build(BuildContext context) {
    final createClassProvider = context.watch<CreateClassProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Title
                const Text(
                  'Crear tema 📝',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),

                // Form
                Form(
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
                          formTopic.title = newValue ?? '';
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
                          formTopic.description = newValue ?? '';
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Button
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        createClassProvider.addTopic(formTopic);
                        context.pop();
                      }
                    },
                    child: const Text('CONTINUAR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
