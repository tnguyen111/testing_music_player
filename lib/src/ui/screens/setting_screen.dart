import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import '../../services/services.dart';
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
          IconButton(onPressed: (){modeSwitchState(ref);}, icon: const Icon(Icons.abc),),
          miniplayer(ref),
        ],
      ),
      bottomNavigationBar: navigationBar(ref),
    );
  }
}
