sealed class Either<L, R> {
  const Either();

  T fold<T>({
    required T Function(L value) onLeft,
    required T Function(R value) onRight,
  });

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;
}

final class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  T fold<T>({
    required T Function(L value) onLeft,
    required T Function(R value) onRight,
  }) =>
      onLeft(value);
}

final class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  T fold<T>({
    required T Function(L value) onLeft,
    required T Function(R value) onRight,
  }) =>
      onRight(value);
}
