import 'package:flutter/material.dart';

import '../eva.dart';
import '../events/event.dart';

class EventBuilder<T> extends StatelessWidget {
  const EventBuilder({
    required this.successBuilder,
    super.key,
    this.initialValue,
    this.emptyBuilder,
    this.failureBuilder,
    this.onEmpty,
    this.onFailure,
    this.onSuccess,
    this.onWaiting,
    this.waitingBuilder,
  });

  final T? initialValue;
  final Widget Function(BuildContext context, EmptyEvent<T> event)? emptyBuilder;
  final Widget Function(BuildContext context, WaitingEvent<T> event)? waitingBuilder;
  final Widget Function(BuildContext context, FailureEvent<T> event)? failureBuilder;
  final Widget Function(BuildContext context, SuccessEvent<T> event) successBuilder;
  final void Function(BuildContext context, EmptyEvent<T> event)? onEmpty;
  final void Function(BuildContext context, WaitingEvent<T> event)? onWaiting;
  final void Function(BuildContext context, FailureEvent<T> event)? onFailure;
  final void Function(BuildContext context, SuccessEvent<T> event)? onSuccess;

  static Widget Function(BuildContext context, IEmptyEvent event) defaultEmptyBuilder = (context, event) => const SizedBox();

  static Widget Function(BuildContext context, IWaitingEvent event) defaultWaitingBuilder = (context, event) => const Center(child: CircularProgressIndicator.adaptive());

  static Widget Function(BuildContext context, IFailureEvent event) defaultFailureBuilder = (context, event) => event.exception is FlutterError
      ? ErrorWidget.withDetails(
          message: (event.exception as FlutterError).message,
          error: event.exception as FlutterError,
        )
      : ErrorWidget(event.exception);

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class QueryEventBuilder<TQueryEvent, TResponseEvent> extends EventBuilder<TResponseEvent> {
  const QueryEventBuilder({
    required this.query,
    required super.successBuilder,
    super.key,
    super.initialValue,
    super.emptyBuilder,
    super.failureBuilder,
    super.onEmpty,
    super.onFailure,
    super.onSuccess,
    super.onWaiting,
    super.waitingBuilder,
  });

  final TQueryEvent query;

  @override
  Widget build(context) {
    Eva.emit(Event.success(query));

    return super.build(context);
  }
}
