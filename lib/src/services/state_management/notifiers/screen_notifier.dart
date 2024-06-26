import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  int mainMenuScreen() {
    state = 0;
    return state;
  }

  int songMenuScreen() {
    state = 1;
    return state;
  }
}
