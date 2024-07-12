import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:testing_music_player/src/my_app.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,

  );
  try {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch(e){
    print(e);
  }
}
