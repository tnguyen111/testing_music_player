import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaylistNotifier extends Notifier<bool> {

  @override
  bool build() {
    return false;
  }

  bool switchState(){
    state = !state;
    return state;
  }
}
