import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/components.dart';

Scaffold mainScreen(WidgetRef ref) {
  return Scaffold(
    appBar: headerBar(ref),
    body: Column(
      children: [
        headerBlock('Your Playlist', ref),
        playlistList(ref),
      ],
    ),
    drawer: sideBar(ref),
  );
}
