import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../components/components.dart';

class EditPlaylistScreen extends StatelessWidget {
  const EditPlaylistScreen({super.key, required this.ref, required this.playlist});
  final WidgetRef ref;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: changePlaylistForm(ref, playlist, false),
    );
  }
}
