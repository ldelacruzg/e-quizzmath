import 'package:e_quizzmath/domain/topic/video_model.dart';
import 'package:e_quizzmath/shared/data/playlist_data.dart';
import 'package:flutter/material.dart';

class PlayListProvider with ChangeNotifier {
  bool _loading = true;
  int _currentVideoIndex = 1;
  final List<VideoModel> _videos = playlist;

  int get currentVideoIndex => _currentVideoIndex;
  List<VideoModel> get videos => _videos;
  VideoModel get currentVideo => _videos[_currentVideoIndex];
  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set currentVideoIndex(int index) {
    _currentVideoIndex = index;
    notifyListeners();
  }
}
