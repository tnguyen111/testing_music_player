import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/models.dart';
import '../ui.dart';
import 'package:flutter/material.dart';

Widget addSongScreen(WidgetRef ref, Playlist  playlist){
  return Scaffold(
    appBar: addSongAppBar(ref,playlist),
    body: Column(
      children: [
        headerBlock('Your Songs', ref),
        addSongList(ref, playlist),
      ],
    ),
  );
}