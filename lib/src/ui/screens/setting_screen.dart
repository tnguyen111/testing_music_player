import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import '../../../main.dart';
import '../../config/config.dart';
import '../../models/global_list.dart';
import '../../models/models.dart';
import '../components/components.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen(this.ref, {super.key});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: headerBar(ref, false),
      body: Column(
        children: [
          headerBlock(
              'Settings',
              ref),
          miniplayer(ref),
        ],
      ),
      bottomNavigationBar: navigationBar(ref),
    );
  }
}
