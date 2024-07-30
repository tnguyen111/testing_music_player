import 'package:flutter_riverpod/flutter_riverpod.dart';


class ModeNotifier extends Notifier<bool> {

  @override
  build() {
    return false;
  }

  bool switchState(){
    state = !state;
    return state;
  }

}
