import 'package:e_quizzmath/domain/topic/video_model.dart';
import 'package:e_quizzmath/presentation/providers/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayListScreen extends StatelessWidget {
  const PlayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PlayListProvider(),
      child: const _PLayListView(),
    );
  }
}

class _PLayListView extends StatelessWidget {
  const _PLayListView();

  @override
  Widget build(BuildContext context) {
    final playListProvider = context.watch<PlayListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vectores'),
      ),
      body: Column(
        children: [
          MyVideoPlayer(urlVideo: playListProvider.currentVideo.videoUrl),
          //Text(playListProvider.currentVideo.videoUrl),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              playListProvider.currentVideo.title,
              style: const TextStyle(
                fontSize: 20,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          ),
          Expanded(
            child: PlayList(
              videos: playListProvider.videos,
            ),
          ),
        ],
      ),
    );
  }
}

class PlayList extends StatelessWidget {
  final List<VideoModel> videos;

  const PlayList({
    super.key,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    final playListProvider = context.watch<PlayListProvider>();
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return PlayListItem(
          video: videos[index],
          onTap: () {
            playListProvider.currentVideoIndex = index;
          },
        );
      },
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  final String urlVideo;
  const MyVideoPlayer({super.key, required this.urlVideo});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    debugPrint('urlVideo: ${widget.urlVideo}');
    super.initState();

    final videoUrl = YoutubePlayer.convertUrlToId(widget.urlVideo);

    _controller = YoutubePlayerController(
      initialVideoId: videoUrl!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playListProvider = context.watch<PlayListProvider>();
    _controller.load(
        YoutubePlayer.convertUrlToId(playListProvider.currentVideo.videoUrl)!);

    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () => debugPrint('Player is ready.'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class PlayListItem extends StatelessWidget {
  final VideoModel video;
  final GestureTapCallback onTap;

  const PlayListItem({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        video.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
      subtitle: Text(video.subtitle),
      leading: Image.network(video.imageUrl),
      onTap: onTap,
    );
  }
}
