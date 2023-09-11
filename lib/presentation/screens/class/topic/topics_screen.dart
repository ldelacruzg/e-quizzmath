import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
import 'package:e_quizzmath/presentation/widgets/custom_not_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyTopicsScreen extends StatelessWidget {
  const MyTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();

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
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Unidades'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          topicProvider.reset();
          context.push('/class/create-topic');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
