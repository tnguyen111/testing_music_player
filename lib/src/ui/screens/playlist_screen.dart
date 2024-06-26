import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../components/components.dart';

Scaffold playlistScreen(WidgetRef ref, Playlist playlist) {
  return Scaffold(
    appBar: headerBar(ref),
    body: Column(
      children: [
        headerBlock('$playlist', ref),
        playlistList(ref),
      ],
    ),
    drawer: sideBar(ref),
  );
}