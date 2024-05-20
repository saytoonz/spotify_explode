import 'user.dart';
import 'track.dart';
import 'spotify_image.dart';
import 'package:spotify_explode/entities/follower.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify_explode/entities/external_urls.dart';
// ignore_for_file: invalid_annotation_target

part 'playlist.freezed.dart';
part 'playlist.g.dart';

@freezed
class Playlist with _$Playlist {
  const Playlist._();
  const factory Playlist({
    required String id,
    @Default('') String name,
    @Default('') String description,
    @Default(false) bool collaborative,
    @JsonKey(name: 'external_urls') ExternalUrls? externalUrls,
    Follower? followers,
    String? href,
    @Default([]) List<SpotifyImage> images,
    User? owner,
    @JsonKey(name: 'primary_color') String? primaryColor,
    @Default(false) bool public,
    @Default('playlist') String type,
    @Default(PlaylistTracks()) PlaylistTracks tracks,
  }) = _Playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);
}

@freezed
class PlaylistTracks with _$PlaylistTracks {
  const PlaylistTracks._();
  const factory PlaylistTracks({
    @Default('') String href,
    @Default([]) List<PlaylistItem> items,
    @Default(0) int offset,
    @Default(0) int total,
    String? next,
    String? previous,
  }) = _PlaylistTracks;

  factory PlaylistTracks.fromJson(Map<String, dynamic> json) =>
      _$PlaylistTracksFromJson(json);
}

@freezed
class PlaylistItem with _$PlaylistItem {
  const PlaylistItem._();
  const factory PlaylistItem({
    @JsonKey(name: 'added_by') User? addedBy,
    required Track track,
    @JsonKey(name: 'is_local') @Default(true) bool isLocal,
  }) = _PlaylistItem;

  factory PlaylistItem.fromJson(Map<String, dynamic> json) =>
      _$PlaylistItemFromJson(json);
}
