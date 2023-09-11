import 'package:e_quizzmath/presentation/providers/class_provider.dart';
import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
import 'package:e_quizzmath/presentation/widgets/home/custom_card_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeTeacherScreen extends StatelessWidget {
  const HomeTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();
    final topicProvider = context.watch<TopicProvider>();

    return Expanded(
      child: GridView.count(
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.7),
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () {
              classProvider.loadClasses();
              context.push('/classes');
            },
            child: const CustomCardItem(
              color: Colors.redAccent,
              title: 'Mis clases',
              icon: Icons.class_rounded,
            ),
          ),
          GestureDetector(
            onTap: () {
              topicProvider.loadTopics();
              context.push('/teacher/topics');
            },
            child: const CustomCardItem(
              color: Colors.orangeAccent,
              title: 'Mis temas',
              icon: Icons.topic_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
