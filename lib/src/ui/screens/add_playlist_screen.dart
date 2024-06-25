import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/components.dart';
import '../../services/services.dart';

class AddPlaylistScreen extends StatelessWidget {
  const AddPlaylistScreen({super.key, required this.ref});
  final WidgetRef ref;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: playlistForm(ref),
    );
  }
}
