import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/models/models.dart';
import '../components/components.dart';

class SongScreen extends ConsumerWidget {
  const SongScreen(this.ref, {super.key});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: headerBar(ref),
      body: Column(
        children: [
          headerBlock(
              '${playlistArray[0].songList.length} Song${(playlistArray[0].songList.length > 1) ? 's' : ''}',
              ref),
          songList(ref, playlistArray[0]),
          miniplayer(ref, true),
        ],
      ),
      bottomNavigationBar: navigationBar(ref),
    );
  }
}
