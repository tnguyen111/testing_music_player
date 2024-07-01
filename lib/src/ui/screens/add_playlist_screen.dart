import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../components/components.dart';

Scaffold addPlaylistScreen (WidgetRef ref, Playlist playlist){
    return Scaffold(
      appBar: AppBar(),
      body: changePlaylistForm(ref, playlist, true),
    );
}
