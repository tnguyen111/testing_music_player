import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../models/models.dart';
import '../components/components.dart';

Scaffold playlistScreen(WidgetRef ref, Playlist playlist) {
  return Scaffold(
    appBar: playlistAppBar(ref, playlist),
    body:
      SingleChildScrollView(controller: ScrollController(),
        child: SizedBox(
          height: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).height - 90,
          width: MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width,
          child: Column(
            children: <Widget>[
              playlistMenuBlock(ref,playlist),
              songList(ref,playlist),
              miniplayer(ref, false),
            ],
          ),
        ),
      ),
  );
}