import 'package:just_audio/just_audio.dart';

import '../../models/models.dart';

void loadNewSong(int i) async {
    await player.seek(index: i, Duration.zero);
    print('new song');
}

void loadNewPlaylist(ConcatenatingAudioSource playlist) async{
    print('new playlist: ${playlist.length}');
    final duration = await player.setAudioSource(playlist,initialIndex: 0);
}

ConcatenatingAudioSource test(){
    return ConcatenatingAudioSource(children:[]);
}
