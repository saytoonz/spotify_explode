import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'repository/repository.dart';
import 'repository/repository_impl.dart';

final getIt = GetIt.instance;

final logger = getIt.get<Logger>();

Future<String?> getClientTokenToken() async {
  try {
    final result = (await Dio().get(
      'https://open.spotify.com/get_access_token?reason=transport&productType=web_player',
    ))
        .data;

    return result['accessToken'];
  } catch (e) {
    logger.e(e);
    return null;
  }
}

typedef AuthTokenGetter = FutureOr<String?> Function();

Future<void> diSetup() async {
  getIt.registerLazySingleton<AuthTokenGetter>(
      () => () => getClientTokenToken());

  getIt.registerSingleton<Logger>(Logger());

  getIt.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      token: getIt.get(),
    ),
  );
}
