import 'package:freezed_annotation/freezed_annotation.dart';

part 'follower.freezed.dart';
part 'follower.g.dart';

@freezed
class Follower with _$Follower {
  const Follower._();
  const factory Follower({
    String? link,
    String? href,
    @Default(0) int total,
  }) = _Follower;

  factory Follower.fromJson(Map<String, dynamic> json) =>
      _$FollowerFromJson(json);
}
