import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../components/components.dart';

Scaffold songPlayerScreen(WidgetRef ref, Song song) {
  return Scaffold(
    appBar: songAppBar(ref),
    body: Column(
      children: [

      ],
    ),
    drawer: sideBar(ref),
  );
}