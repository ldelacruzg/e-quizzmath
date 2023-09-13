import 'package:e_quizzmath/presentation/providers/topic_provider.dart';
import 'package:e_quizzmath/presentation/widgets/custom_not_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateUnitScreen extends StatelessWidget {
  const CreateUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topicProvider = context.watch<TopicProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear unidad'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Form para la información general
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Información General',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Form(
              key: topicProvider.formKeyInfoGeneral,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                    onSaved: (newValue) =>
                        topicProvider.formCreateUnit.title = newValue ?? '',
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      prefixIcon: Icon(Icons.description_rounded),
                    ),
                    onSaved: (newValue) => topicProvider
                        .formCreateUnit.description = newValue ?? '',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Form para la playlist
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Playlist',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Form(
                    key: topicProvider.formKeyPlaylist,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'URL Video',
                        prefixIcon: Icon(Icons.link_rounded),
                      ),
                      onSaved: (newValue) {
                        topicProvider.formCreateUnit.urlVideo =
                            newValue ?? 'hola';
                      },
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    topicProvider.addVideo();
                  },
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // Lista de videos
            topicProvider.numVideos <= 0
                ? const CustomNotContent(message: 'No hay videos')
                : Expanded(
                    child: ListView.builder(
                      itemCount: topicProvider.numVideos,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            topicProvider.formCreateUnit.playlist[index],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              topicProvider.deleteVideo(index);
                            },
                            icon: const Icon(Icons.delete_rounded),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          topicProvider.saveFormCreateUnit();
          context.pop();
        },
        child: const Icon(Icons.save_rounded),
      ),
    );
  }
}
