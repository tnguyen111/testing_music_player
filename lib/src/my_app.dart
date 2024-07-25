import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../main.dart';
import 'ui/ui.dart';
import 'services/services.dart';

bool started = false;

Future micPerAsk() async {
  print('In Microphone permission method');
  var status = await Permission.microphone.status;
  if (status.isDenied) {
    await Permission.microphone.request();
    status = await Permission.microphone.status;
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
    status = await Permission.microphone.status;
  }

  if (status.isPermanentlyDenied) {
    exit(0);
  }
}

Future audioPerAsk() async {
  print('In Microphone permission method');
  var status = await Permission.audio.status;
  if (status.isDenied) {
    await Permission.audio.request();
    status = await Permission.audio.status;
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
    status = await Permission.audio.status;
  }

  if (status.isPermanentlyDenied) {
    exit(0);
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);
    AppLifecycleListener(onResume: () => playlistSwitchState(ref));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    bool modeState = modeWatchState(ref);
    playlistWatchState(ref);
    int screenState = screenWatchState(ref);
    if (started == false) {
      IsarHelper().setSongList(ref);
      IsarHelper().setPlaylistList(ref);
      micPerAsk();
      audioPerAsk();
      started = true;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: ContextKey.navKey,
      theme: (modeState) ? theme.light() : theme.dark(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      //color: Colors.white,
      home: Stack(children: [
        (screenState == 0)
            ? SettingScreen(ref)
            : (screenState == 1)
                ? MainScreen(ref)
                : SongScreen(ref),
      ]),
    );
  }
}
