import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongNotifier extends Notifier<int> {

  @override
  int build() {
    return 0;
  }

  int playSong() {
    state = 0;
    return state;
  }

  int pauseSong() {
    state = 1;
    return state;
  }

  int changeSong(){
    state = 2;
    return state;
  }


}
