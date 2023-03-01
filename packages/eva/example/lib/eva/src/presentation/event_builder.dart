import 'package:flutter/material.dart';

import '../../eva.dart';

class EventBuilder<TEventState> extends StatelessWidget {
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

  final TEventState? initialValue;
  final Widget Function(BuildContext context, Event<TEventState> event)? otherwiseBuilder;
  final Widget Function(BuildContext context, EmptyEvent<TEventState> event)? emptyBuilder;
  final Widget Function(BuildContext context, WaitingEvent<TEventState> event)? waitingBuilder;
  final Widget Function(BuildContext context, FailureEvent<TEventState> event)? failureBuilder;
  final Widget Function(BuildContext context, SuccessEvent<TEventState> event) successBuilder;
  final void Function(BuildContext context, Event<TEventState> event)? onOtherwise;
  final void Function(BuildContext context, EmptyEvent<TEventState> event)? onEmpty;
  final void Function(BuildContext context, WaitingEvent<TEventState> event)? onWaiting;
  final void Function(BuildContext context, FailureEvent<TEventState> event)? onFailure;
  final void Function(BuildContext context, SuccessEvent<TEventState> event)? onSuccess;

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
    return StreamBuilder<Event<TEventState>>(
      initialData: initialValue == null ? Event<TEventState>.waiting() : Event<TEventState>.success(initialValue as TEventState),
      stream: Eva.getEventsStream<TEventState>(hashCode),
      builder: (innerContext, snapshot) => _buildEvent(context, innerContext, snapshot),
    );
  }

  Widget _buildEvent(BuildContext outerContext, BuildContext context, AsyncSnapshot<Event<TEventState>> snapshot) {
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

class CommandEventBuilder<TCommand extends Command, TEventState> extends EventBuilder<TEventState> {
  const CommandEventBuilder({
    required this.command,
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

  final TCommand command;

  @override
  Widget build(context) {
    Eva.dispatchCommand(command);

    return super.build(context);
  }
}
