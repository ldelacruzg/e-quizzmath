import 'package:flutter/material.dart';

class CreateClassScreen extends StatelessWidget {
  const CreateClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear clase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: 0.2,
                      minHeight: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),

            // Title
            const Text(
              'Crear clase 📚',
              style: TextStyle(
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

            // Form
            Form(
              child: Column(
                children: [
                  // Title
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title_rounded),
                      labelText: 'Título',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.description_rounded),
                      labelText: 'Descripción',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Add button
          FloatingActionButton(
            heroTag: const Key('add_button'),
            onPressed: () {},
            child: const Icon(Icons.add_rounded),
          ),
          const SizedBox(height: 10),

          // Next button
          FloatingActionButton(
            heroTag: const Key('next_button'),
            onPressed: () {},
            child: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          const SizedBox(height: 10),

          // Back button
          FloatingActionButton(
            heroTag: const Key('back_button'),
            onPressed: () {},
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ],
      ),
    );
  }
}
