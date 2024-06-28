import 'models.dart';
import 'package:just_audio/just_audio.dart';
List<Playlist> playlistArray = [];

ConcatenatingAudioSource songArray = ConcatenatingAudioSource(children:[],useLazyPreparation: true,shuffleOrder: DefaultShuffleOrder());

