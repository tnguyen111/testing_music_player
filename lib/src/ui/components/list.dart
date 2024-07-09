import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../main.dart';
import '../../services/services.dart';
import '../ui.dart';
import 'components.dart';
import 'package:testing_music_player/src/models/models.dart';




Widget playlistList(WidgetRef ref) {
  final ScrollController scrollController = ScrollController();
  return Expanded(
    child: ListView.builder(
        itemCount: playlistArray.length + 1,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (context, index) {
          return (index < playlistArray.length)
              ? playlistBlock(ref, playlistArray[index])
              : playlistAddBlock(ref);
        }),
  );
}

Widget songList(WidgetRef ref,ConcatenatingAudioSource songList) {
  final ScrollController scrollController = ScrollController();

  return Expanded(
    child: ListView.builder(
        itemCount: songList.children.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (context, index) {
          if(songList.children.isNotEmpty) {
            return songBlock(ref, songList , index);
          }
          return Container();
        }),
  );
}

Widget addSongList(WidgetRef ref,Playlist playlist) {
  final ScrollController scrollController = ScrollController();

  return Expanded(
    child: ListView.builder(
        itemCount: songArray.children.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (context, index) {
          return addSongBlock(ref, playlist, index);
        }),
  );
}
