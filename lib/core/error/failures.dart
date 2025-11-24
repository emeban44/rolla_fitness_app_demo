import 'package:equatable/equatable.dart';

/// Base failure class for error handling
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure when data cannot be loaded
class DataFailure extends Failure {
  const DataFailure(super.message);
}

/// Failure when cache/local storage fails
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure when parsing JSON fails
class ParseFailure extends Failure {
  const ParseFailure(super.message);
}
