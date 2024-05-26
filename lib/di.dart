import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

final logger = getIt.get<Logger>();

Future<void> diSetup() async {
  getIt.registerSingleton<Logger>(Logger());
}
