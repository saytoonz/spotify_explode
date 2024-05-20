import 'spotify_image.dart';
import 'package:spotify_explode/entities/follower.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
class Artist with _$Artist {
  const Artist._();
  const factory Artist({
    @Default('') String id,
    @Default('') String name,
    Follower? followers,
    @Default([]) List<String> genres,
    @Default([]) List<SpotifyImage> images,
    @Default(0) int popularity,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
