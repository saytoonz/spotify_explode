import 'follower.dart';
import 'spotify_image.dart';
import 'external_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();
  const factory User({
    required String id,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @JsonKey(name: 'external_urls') ExternalUrls? externalUrls,
    @Default('') String href,
    @Default('user') String type,
    @Default('') String uri,
    @Default([]) List<SpotifyImage> images,
    Follower? followers,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
