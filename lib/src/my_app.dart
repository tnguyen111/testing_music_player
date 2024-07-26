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

Future permissionAsk(BuildContext context, WidgetRef ref) async {
  print('In Permission Method');

  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.audio,
  ].request();

  if (statuses[Permission.audio]!.isPermanentlyDenied || true) {
    print('Showed Rationale');
    await showRationaleDialog(ref);
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
      permissionAsk(context, ref);
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
