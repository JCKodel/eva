import 'package:meta/meta.dart';

import '../events/event.dart';

/// Types of Response
enum ResponseType {
  /// A failure has ocurred (exception)
  failure,

  /// The result is empty (null)
  empty,

  /// A value is being returned
  success,
}

/// This class holds results for an operation.
///
/// It serves 2 purposes:
///
/// 1) Avoid using `null` values (it will be an `empty` response instead)
///
/// 2) Avoid `try/catch` (it will be a `failure` response instead, with the thrown exception)
@immutable
class Response<T> {
  /// Creates a new `failure` response, with the `exception`
  const Response.failure(Object exception)
      : _type = ResponseType.failure,
        _exception = exception,
        _value = null;

  /// Creates a new `empty` response
  const Response.empty()
      : _type = ResponseType.empty,
        _exception = null,
        _value = null;

  /// Creates a new `success` response, with a `value`
  ///
  /// If `value` is `null`, it will generate an `empty` response instead.
  const Response.success(T? value)
      : _type = value == null ? ResponseType.empty : ResponseType.success,
        _exception = null,
        _value = value;

  final ResponseType _type;
  final Object? _exception;
  final T? _value;

  /// This is a fancy `switch` that runs `failure`, `empty` or `success`, depending
  /// on which type of result this is.
  TResult match<TResult>({
    required TResult Function(Object exception) failure,
    required TResult Function() empty,
    required TResult Function(dynamic value) success,
  }) {
    switch (_type) {
      case ResponseType.failure:
        return failure(_exception!);
      case ResponseType.empty:
        return empty();
      case ResponseType.success:
        return success(_value);
    }
  }

  /// This is the same as `match`, but you can omit cases
  ///
  /// Any omitted case will fall to `otherwise`
  TResult maybeMatch<TResult>({
    required TResult Function() otherwise,
    TResult Function(Object exception)? failure,
    TResult Function()? empty,
    TResult Function(dynamic value)? success,
  }) {
    switch (_type) {
      case ResponseType.failure:
        return failure == null ? otherwise() : failure(_exception!);
      case ResponseType.empty:
        return empty == null ? otherwise() : empty();
      case ResponseType.success:
        return success == null ? otherwise() : success(_value);
    }
  }

  /// Converts this response to an `Event<TResult>`, so if this response is
  /// empty, it will convert it to Event<TResult>.empty and so on
  Event<TResult> mapToEvent<TResult>({TResult Function(T value)? success}) {
    return match(
      success: success == null ? (v) => Event<TResult>.success(v as TResult) : (value) => Event<TResult>.success(success(value as T)),
      empty: () => Event<TResult>.empty(),
      failure: (exception) => Event<TResult>.failure(exception),
    );
  }

  /// Maps this `Response<T>` to a `Response<TResult>`.
  Response<TResult> map<TResult>({
    required Response<TResult> Function(T value) success,
    Response<TResult> Function(Object exception)? failure,
    Response<TResult> Function()? empty,
  }) {
    switch (_type) {
      case ResponseType.failure:
        return failure == null ? Response<TResult>.failure(_exception!) : failure(_exception!);
      case ResponseType.empty:
        return empty == null ? Response<TResult>.empty() : empty();
      case ResponseType.success:
        return success(_value as T);
    }
  }

  /// Maps this `Response<T>` to a `Response<TResult>`, using async functions.
  Future<Response<TResult>> mapAsync<TResult>({
    required Future<Response<TResult>> Function(T value) success,
    Future<Response<TResult>> Function(Object exception)? failure,
    Future<Response<TResult>> Function()? empty,
  }) async {
    switch (_type) {
      case ResponseType.failure:
        return failure == null ? Response<TResult>.failure(_exception!) : await failure(_exception!);
      case ResponseType.empty:
        return empty == null ? Response<TResult>.empty() : await empty();
      case ResponseType.success:
        return success(_value as T);
    }
  }

  @override
  String toString() {
    switch (_type) {
      case ResponseType.failure:
        return "{FailureOf<${_exception.runtimeType}>:${_exception}}";
      case ResponseType.empty:
        return "{Empty}";
      case ResponseType.success:
        return "{Success<${_value.runtimeType}>:${_value}}";
    }
  }
}
