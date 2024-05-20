import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_image.freezed.dart';
part 'spotify_image.g.dart';

@freezed
class SpotifyImage with _$SpotifyImage {
  const SpotifyImage._();
  const factory SpotifyImage({
    required String url,
    num? height,
    num? width,
  }) = _SpotifyImage;

  factory SpotifyImage.fromJson(Map<String, dynamic> json) =>
      _$SpotifyImageFromJson(json);
}
