import 'models.dart';
import 'package:just_audio/just_audio.dart';
List<Playlist> playlistArray = [];
bool playlistRemoving = false;

ConcatenatingAudioSource songArray = ConcatenatingAudioSource(children:[],useLazyPreparation: true,shuffleOrder: DefaultShuffleOrder());

