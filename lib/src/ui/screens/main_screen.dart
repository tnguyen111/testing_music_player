import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../../models/global_list.dart';
import '../../models/models.dart';
import '../components/components.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen(this.ref, {super.key});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: headerBar(ref, false),
      body: Column(
        children: [
          headerBlock(
              '${playlistArray.length - 1} Playlist${(playlistArray.length - 1 > 1) ? 's' : ''}',
              ref),
          playlistList(ref),
          miniplayer(ref),
        ],
      ),
      bottomNavigationBar: navigationBar(ref),
    );
  }
}
