import 'dart:async';

abstract class Usecase<Type, Params> {
  FutureOr<Type> call(Params params);
}

class NoParams {
  const NoParams();
}
