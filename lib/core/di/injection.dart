import 'package:get_it/get_it.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // Feature modules will register their dependencies here
  // Example: initScoresFeature();
}
