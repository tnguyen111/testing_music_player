import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/components.dart';

Scaffold addPlaylistScreen (WidgetRef ref){
    return Scaffold(
      appBar: AppBar(),
      body: playlistForm(ref, Image.network('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain')),
    );
}
