import 'spotify_image.dart';
import 'package:spotify_explode/entities/artist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// ignore_for_file: invalid_annotation_target

part 'album.freezed.dart';
part 'album.g.dart';

@freezed
class Album with _$Album {
  const Album._();
  const factory Album({
    required String id,
    @Default('') String label,
    @Default('') String name,
    @JsonKey(name: 'album_type') @Default('album') String albumType,
    @Default(0) num popularity,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'total_tracks') @Default(0) num totalTracks,
    @JsonKey(name: 'available_markets')
    @Default([])
    List<String> availableMarkets,
    @Default([]) List<Artist> artists,
    @Default([]) List<SpotifyImage> images,
    @Default([]) List<String> genres,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}
