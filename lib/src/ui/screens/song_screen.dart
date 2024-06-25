import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/components.dart';

Scaffold songScreen(WidgetRef ref) {
  return Scaffold(
    appBar: headerBar(ref),
    body: Column(
      children: [
        headerBlock('Your Songs', ref),
        songList(ref),
      ],
    ),
    drawer: sideBar(ref),
  );
}
