import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:testing_music_player/src/my_app.dart';


class ContextKey {
  static final navKey = GlobalKey<NavigatorState>();
  static final appWidth = MediaQuery.sizeOf(ContextKey.navKey.currentContext!).width;
  static final appHeight = MediaQuery.sizeOf(ContextKey.navKey.currentContext!).height;
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
