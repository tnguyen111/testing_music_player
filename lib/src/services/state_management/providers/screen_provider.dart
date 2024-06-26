import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/screen_notifier.dart';

final screenProvider = NotifierProvider<ScreenNotifier, int>(
  () {
    return ScreenNotifier();
  },
);
