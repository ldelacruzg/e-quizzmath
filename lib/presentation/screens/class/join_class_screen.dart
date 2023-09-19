import 'package:e_quizzmath/presentation/providers/class_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class JoinClassScreen extends StatelessWidget {
  const JoinClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Unirse a una clase 📚',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Introduce el código de la clase que te ha proporciado tu profesor; si no lo tienes, contacta con él para que te lo facilite.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 35),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Código de la clase',
                      suffixIcon: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (classProvider.findClassCode.isNotEmpty) {
                            classProvider.classCodeExist().then((value) {
                              if (!value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'El código de la clase no existe',
                                    ),
                                  ),
                                );
                              }
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error al buscar el código de la clase',
                                  ),
                                ),
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.search_rounded),
                      ),
                    ),
                    onChanged: (value) {
                      classProvider.findClassCode = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  classProvider.classFound.id.isEmpty
                      ? const SizedBox.shrink()
                      : classProvider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Información de la clase',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Título: ${classProvider.classFound.title}'),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Descripción: ${classProvider.classFound.description}'),
                                  const SizedBox(height: 10),
                                  Text(
                                      'Profesor: ${classProvider.teacherOfTheClassFound.fullName}'),
                                ],
                              ),
                            ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: classProvider.classFound.id.isEmpty
                        ? null
                        : () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        '¿Estás seguro de unirte a esta clase?'),
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
                                  );
                                }).then((value) {
                              if (value) {
                                classProvider.joinClass().then((value) {
                                  if (value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                '¡Te has unido a la clase!'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  context.go('/home');
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Error al unirse a la clase',
                                        ),
                                      ),
                                    );
                                  }
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Error al unirse a la clase, contacta con el profesor',
                                      ),
                                    ),
                                  );
                                });
                              }
                            });
                          },
                    child: const Text('UNIRSE'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
