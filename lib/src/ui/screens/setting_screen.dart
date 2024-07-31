import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import '../components/components.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen(this.ref, {super.key});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: headerBar(ref),
      body: Column(
        children: [
          settingList(ref),
          miniplayer(ref, true),
        ],
      ),
      bottomNavigationBar: navigationBar(ref),
    );
  }
}
