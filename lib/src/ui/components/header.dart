import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components.dart';


AppBar headerBar(WidgetRef ref){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return menuIcon(context);
      },
    ),
    actions: [searchIcon(ref)],
  );
}

