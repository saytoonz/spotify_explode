import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_urls.freezed.dart';
part 'external_urls.g.dart';

@freezed
class ExternalUrls with _$ExternalUrls {
  const ExternalUrls._();
  const factory ExternalUrls({
    @Default('') String spotify,
  }) = _ExternalUrls;

  factory ExternalUrls.fromJson(Map<String, dynamic> json) =>
      _$ExternalUrlsFromJson(json);
}
