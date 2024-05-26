import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'repository/spotify_repository.dart';
import 'repository/spotify_repository_impl.dart';

final spotifyGetIt = GetIt.instance;

SpotifyRepository get spotify => spotifyGetIt<SpotifyRepository>();

Future<String?> getSpotifyClientTokenToken() async {
  try {
    final result = (await Dio().get(
      'https://open.spotify.com/get_access_token?reason=transport&productType=web_player',
    ))
        .data;
    return result['accessToken'];
  } catch (e) {
    return null;
  }
}

typedef SpotifyTokenGetter = FutureOr<String?> Function();

class Spotify {
  static Future<void> ensureInitialized() async {
    spotifyGetIt.registerLazySingleton<SpotifyTokenGetter>(
        () => () => getSpotifyClientTokenToken());

    spotifyGetIt.registerLazySingleton<SpotifyRepository>(
      () => SpotifyRepositoryImpl(spotifyGetIt.get()),
    );
  }
}
