import 'album.dart';
import 'artist.dart';
import 'external_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// ignore_for_file: invalid_annotation_target

part 'track.freezed.dart';
part 'track.g.dart';

@freezed
class Track with _$Track {
  const Track._();
  const factory Track({
    @Default('') String id,
    @JsonKey(name: 'external_urls') ExternalUrls? externalUrls,
    @JsonKey(name: 'name') @Default('') String title,
    @JsonKey(name: 'track_number') @Default(0) int trackNumber,
    @Default(0) int popularity,
    @JsonKey(name: 'available_markets')
    @Default([])
    List<String> availableMarkets,
    @JsonKey(name: 'disc_number') @Default(0) int discNumber,
    @JsonKey(name: 'duration_ms') @Default(0) int durationMs,
    @Default(false) bool explicit,
    @JsonKey(name: 'is_local') @Default(false) bool isLocal,
    @JsonKey(name: 'preview_url') @Default('') String previewUrl,
    @Default([]) List<Artist> artists,
    Album? album,
    String? href,
  }) = _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
