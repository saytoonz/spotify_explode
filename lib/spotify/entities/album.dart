import 'track.dart';
import 'artist.dart';
import 'spotify_image.dart';
import 'external_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target

part 'album.freezed.dart';
part 'album.g.dart';

@freezed
class Album with _$Album {
  const Album._();
  const factory Album({
    required String id,

    ///Label that released the album
    @Default('') String label,
    @Default('') String name,
    @Default('') String href,
    @Default('album') String type,
    @JsonKey(name: 'album_type') @Default('album') String albumType,
    @Default(0) num popularity,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'release_date_precision') String? releaseDatePrecision,
    @JsonKey(name: 'total_tracks') @Default(0) num totalTracks,
    @JsonKey(name: 'available_markets')
    @Default([])
    List<String> availableMarkets,
    @Default([]) List<Artist> artists,
    AlbumTracks? tracks,
    @Default([]) List<SpotifyImage> images,
    @Default([]) List<String> genres,
    @Default([]) List<Copyright> copyrights,
    @JsonKey(name: 'external_urls') ExternalUrls? externalUrls,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}

@freezed
class Copyright with _$Copyright {
  const Copyright._();
  const factory Copyright({
    String? text,
    String? type,
  }) = _Copyright;

  factory Copyright.fromJson(Map<String, dynamic> json) =>
      _$CopyrightFromJson(json);
}

@freezed
class AlbumTracks with _$AlbumTracks {
  const AlbumTracks._();
  const factory AlbumTracks({
    @Default('') String href,
    @Default([]) List<Track> items,
    @Default(0) int offset,
    @Default(0) int total,
    String? next,
    String? previous,
  }) = _AlbumTracks;

  factory AlbumTracks.fromJson(Map<String, dynamic> json) =>
      _$AlbumTracksFromJson(json);
}
