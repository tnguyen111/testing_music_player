import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/song_notifier.dart';

final songProvider = NotifierProvider<SongNotifier, int>(() {
  return SongNotifier();
});
