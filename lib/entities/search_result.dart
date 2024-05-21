import 'package:spotify_explode/entities/track.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchTrackResult with _$SearchTrackResult {
  const SearchTrackResult._();
  const factory SearchTrackResult({
    @Default('') String href,
    @Default([]) List<Track> items,
    @Default(0) int offset,
    @Default(0) int total,
    String? next,
    String? previous,
  }) = _SearchTrackResult;

  factory SearchTrackResult.fromJson(Map<String, dynamic> json) =>
      _$SearchTrackResultFromJson(json);
}

@freezed
class SearchAlbumResult with _$SearchAlbumResult {
  const SearchAlbumResult._();
  const factory SearchAlbumResult({
    @Default('') String href,
    @Default([]) List<Track> items,
    @Default(0) int offset,
    @Default(0) int total,
    String? next,
    String? previous,
  }) = _SearchAlbumResult;

  factory SearchAlbumResult.fromJson(Map<String, dynamic> json) =>
      _$SearchAlbumResultFromJson(json);
}

@freezed
class SearchArtistResult with _$SearchArtistResult {
  const SearchArtistResult._();
  const factory SearchArtistResult({
    @Default('') String href,
    @Default([]) List<Track> items,
    @Default(0) int offset,
    @Default(0) int total,
    String? next,
    String? previous,
  }) = _SearchArtistResult;

  factory SearchArtistResult.fromJson(Map<String, dynamic> json) =>
      _$SearchArtistResultFromJson(json);
}

@freezed
class SearchPlaylistResult with _$SearchPlaylistResult {
  const SearchPlaylistResult._();
  const factory SearchPlaylistResult({
    @Default('') String href,
    @Default([]) List<Track> items,
    @Default(0) int offset,
    @Default(0) int total,
    String? next,
    String? previous,
  }) = _SearchPlaylistResult;

  factory SearchPlaylistResult.fromJson(Map<String, dynamic> json) =>
      _$SearchPlaylistResultFromJson(json);
}
