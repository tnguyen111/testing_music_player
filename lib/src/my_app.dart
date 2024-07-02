import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:testing_music_player/src/services/state_management/helper_funcs/helper_funcs.dart';
import '../main.dart';
import 'ui/ui.dart';
import 'services/services.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool modeState = modeWatchState(ref);
    playlistWatchState(ref);
    int screenState = screenWatchState(ref);
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      theme: (modeState) ? lightTheme() : darkTheme(),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      color: Colors.white,
      home: (screenState == 0)
          ? mainScreen(ref)
          : songScreen(ref),
    );
  }
}
