import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../../models/models.dart';
import '../ui.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({super.key, required this.playlist, required this.ref});
  final Playlist playlist;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 5,
      height: 300,
      child: GestureDetector(
        onTap: () {
          // Change!
          Navigator.push(
            ContextKey.navKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => playlistScreen(ref, playlist)),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 160,
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                child: playlist.getImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 14, top: 8.0, bottom: 8.0, right: 14),
              child: playlistText(
                ref,
                playlist.playlistName_,
              ),
            ),
          ],
        ),
      ),
    );
  }
}