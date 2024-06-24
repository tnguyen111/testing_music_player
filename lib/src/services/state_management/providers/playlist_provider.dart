import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_api_twitter/src/services/services.dart';


final playlistProvider = NotifierProvider<PlaylistNotifier, bool>(() {
  return PlaylistNotifier();
});
