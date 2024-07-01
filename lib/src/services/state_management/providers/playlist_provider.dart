import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/services/services.dart';


final playlistProvider = NotifierProvider<PlaylistNotifier, bool>(() {
  return PlaylistNotifier();
});
