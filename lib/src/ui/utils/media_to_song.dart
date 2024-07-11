import "package:just_audio_background/just_audio_background.dart";
import "../../models/models.dart";

SongDetails toSongDetails (MediaItem media){
  return SongDetails(
    songPath: media.id,
    songName: media.title,
    songAuthor: media.artist??'',
    songDurationData: media.duration.toString(),
  );
}