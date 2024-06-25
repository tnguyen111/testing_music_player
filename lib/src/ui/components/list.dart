import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components.dart';
import 'package:testing_api_twitter/src/models/models.dart';




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

Widget songList(WidgetRef ref) {
  final ScrollController scrollController = ScrollController();

  return Expanded(
    child: ListView.builder(
        itemCount: songArray.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (context, index) {
          return songBlock(ref, songArray[index]);
        }),
  );
}
