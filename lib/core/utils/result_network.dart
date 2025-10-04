sealed class ResultNetwork<T> {}

class SuccessNetwork<T> extends ResultNetwork<T> {
  SuccessNetwork(this.data);
  final T data;
}

class ErrorNetwork<T> extends ResultNetwork<T> {
  ErrorNetwork(this.exception);
  final Exception exception;
}
