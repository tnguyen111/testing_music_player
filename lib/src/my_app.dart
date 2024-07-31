import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import 'models/global_list.dart';
import 'ui/ui.dart';
import 'services/services.dart';

bool started = false;

Future permissionAsk(BuildContext context, WidgetRef ref) async {
  print('In Permission Method');

  Map<Permission, PermissionStatus> statuses = await [
    Permission.microphone,
    Permission.audio,
  ].request();

  if (await Permission.audio.isPermanentlyDenied || !(await Permission.audio.isGranted)) {
    print('Showed Rationale');
    await showRationaleDialog(ref);
  } else if(await Permission.audio.isGranted){
    setupMode(ref);
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);
    AppLifecycleListener(onResume: () => playlistSwitchState(ref));
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    bool modeState = modeWatchState(ref);
    playlistWatchState(ref);
    int screenState = screenWatchState(ref);
    importingFile.addListener(() => playlistSwitchState(ref));
    if (started == false) {
      permissionAsk(context, ref);
      IsarHelper().setSongList(ref);
      print(playlistArray.length);
      started = true;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: ContextKey.navKey,
      theme: (modeState) ? theme.light() : theme.dark(),
      //color: Colors.white,
      home: (screenState == 0)
          ? SettingScreen(ref)
          : (screenState == 1)
              ? MainScreen(ref)
              : SongScreen(ref),
    );
  }
}
