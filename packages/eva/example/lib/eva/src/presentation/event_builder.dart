import 'package:flutter/material.dart';

import '../../eva.dart';

class EventBuilder<T> extends StatelessWidget {
  const EventBuilder({
    required this.successBuilder,
    super.key,
    this.emptyBuilder,
    this.failureBuilder,
    this.initialValue,
    this.onEmpty,
    this.onFailure,
    this.onOtherwise,
    this.onSuccess,
    this.onWaiting,
    this.otherwiseBuilder,
    this.waitingBuilder,
  });

  final T? initialValue;
  final Widget Function(BuildContext context, Event<T> event)? otherwiseBuilder;
  final Widget Function(BuildContext context, EmptyEvent<T> event)? emptyBuilder;
  final Widget Function(BuildContext context, WaitingEvent<T> event)? waitingBuilder;
  final Widget Function(BuildContext context, FailureEvent<T> event)? failureBuilder;
  final Widget Function(BuildContext context, SuccessEvent<T> event) successBuilder;
  final void Function(BuildContext context, Event<T> event)? onOtherwise;
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
    return StreamBuilder<Event<T>>(
      initialData: initialValue == null ? Event<T>.waiting() : Event<T>.success(initialValue as T),
      stream: Eva.getEventsStream<T>(),
      builder: (innerContext, snapshot) => _buildEvent(context, innerContext, snapshot),
    );
  }

  Widget _buildEvent(BuildContext outerContext, BuildContext context, AsyncSnapshot<Event<T>> snapshot) {
    Log.verbose(() => "${outerContext} received ${snapshot.data}");

    if (snapshot.hasError) {
      throw snapshot.error!;
    }

    final event = snapshot.data!;

    Log.verbose(() => "${runtimeType} is building ${event}");

    return event.match(
      empty: (e) {
        (onEmpty ?? onOtherwise)?.call(context, e);
        return (emptyBuilder ?? otherwiseBuilder ?? defaultEmptyBuilder)(context, e);
      },
      failure: (e) {
        (onFailure ?? onOtherwise)?.call(context, e);
        return (failureBuilder ?? otherwiseBuilder ?? defaultFailureBuilder)(context, e);
      },
      waiting: (e) {
        (onWaiting ?? onOtherwise)?.call(context, e);
        return (waitingBuilder ?? otherwiseBuilder ?? defaultWaitingBuilder)(context, e);
      },
      success: (e) {
        onSuccess?.call(context, e);
        return successBuilder(context, e);
      },
    );
  }
}

class QueryEventBuilder<TQueryEvent, TResponseEvent> extends EventBuilder<TResponseEvent> {
  const QueryEventBuilder({
    required this.query,
    required super.successBuilder,
    super.emptyBuilder,
    super.failureBuilder,
    super.initialValue,
    super.key,
    super.onEmpty,
    super.onFailure,
    super.onOtherwise,
    super.onSuccess,
    super.onWaiting,
    super.otherwiseBuilder,
    super.waitingBuilder,
  });

  final TQueryEvent query;

  @override
  Widget build(context) {
    Eva.emit(Event.success(query));

    return super.build(context);
  }
}
