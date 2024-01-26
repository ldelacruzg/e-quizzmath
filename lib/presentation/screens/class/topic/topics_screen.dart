import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
import 'package:e_quizzmath/presentation/providers/unit_provider.dart';
import 'package:e_quizzmath/presentation/providers/user_logged_in_provider.dart';
import 'package:e_quizzmath/presentation/widgets/custom_not_content.dart';
import 'package:e_quizzmath/shared/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyTopicsScreen extends StatelessWidget {
  const MyTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();
    final unitProvider = context.watch<UnitProvider>();
    final userLoggedProvider = context.watch<UserLoggedInProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis temas'),
      ),
      body: topicProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : topicProvider.topics.isEmpty
              ? const CustomNotContent(message: 'No hay temas creados')
              : ListView.builder(
                  itemCount: topicProvider.topics.length,
                  itemBuilder: (context, index) {
                    final topic = topicProvider.topics[index];
                    return ListTile(
                      leading: const Icon(Icons.topic_rounded),
                      title: Text(
                        topic.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(topic.description),
                      onTap: () {
                        final topicRef = Funtions.getDocumentReference(
                          Collections.topics,
                          topic.id,
                        );

                        unitProvider.loadUnits(topicRef);
                        context.push('/class/topic/units');
                      },
                    );
                  },
                ),
      floatingActionButton:
          userLoggedProvider.isTeacher ? _onCreateTopicButton(context) : null,
    );
  }

  FloatingActionButton _onCreateTopicButton(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();

    return FloatingActionButton(
      onPressed: () {
        topicProvider.reset();
        context.push('/class/create-topic');
      },
      child: const Icon(Icons.add),
    );
  }
}
