import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../components/components.dart';

Scaffold songPlayerScreen(WidgetRef ref, Playlist playlist, int index) {
  return Scaffold(
    appBar: songAppBar(ref),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          songWaveForm(ref, true),
          songNameBlock(ref),
          songProgressBar(ref, playlist, true),
          const SizedBox(height: 50),
          songIconBlock(ref, playlist, index,true),
        ],
      ),
    ),
  );
}
