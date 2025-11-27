import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'scores_injection.config.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Configures all dependencies using Injectable's code generation.
/// Dependencies are registered automatically by scanning for @injectable and @lazySingleton
/// annotations throughout the codebase. Run 'flutter pub run build_runner build' to generate.
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
