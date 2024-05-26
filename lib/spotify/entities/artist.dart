import 'follower.dart';
import 'spotify_image.dart';
import 'external_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// ignore_for_file: invalid_annotation_target

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
class Artist with _$Artist {
  const Artist._();
  const factory Artist({
    @Default('') String id,
    @Default('') String name,
    @Default('') String href,
    @Default('artist') String type,
    Follower? followers,
    @Default([]) List<String> genres,
    @Default([]) List<SpotifyImage> images,
    @Default(0) int popularity,
    @JsonKey(name: 'external_urls') ExternalUrls? externalUrls,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
