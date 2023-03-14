import 'package:flutter/material.dart';

import '../../eva.dart';

/// Inherited widget that holds the last event captured by the
/// previous `EventBuilder<TEventState>` or `CommandEventBuilder<TEventState>`
@immutable
class EventState<TEventState> extends InheritedWidget {
  const EventState({required this.state, required super.child, super.key});

  /// The last dispatched even of `TEventState`
  final Event<TEventState> state;

  @override
  bool updateShouldNotify(EventState<TEventState> oldWidget) {
    return state != oldWidget.state;
  }

  /// Gets the last event built by a previous builder
  ///
  /// It will throw an exception if there are no events ever built of that
  /// type (just in case you are trying to get an EventState at some point of
  /// the widget tree where there are no ancestors of type EventBuilder)
  static EventState<TEventState> of<TEventState>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EventState<TEventState>>()!;
  }
}

/// Listens to events of type `TEventState` and rebuilds using
/// the appropriated arguments depending on the type of the Event
class EventBuilder<TEventState> extends StatelessWidget {
  const EventBuilder({
    this.successBuilder,
    super.key,
    this.emptyBuilder,
    this.failureBuilder,
    this.initialValue,
    this.successFilter,
    this.onEmpty,
    this.onFailure,
    this.onOtherwise,
    this.onSuccess,
    this.onWaiting,
    this.otherwiseBuilder,
    this.waitingBuilder,
  }) : assert(successBuilder != null || otherwiseBuilder != null);

  /// The initial value used when this builder is in the waiting state.
  final Event<TEventState>? initialValue;

  /// The builder to run if no other build is provided (it will ignore the default builders)
  final Widget Function(BuildContext context, Event<TEventState> event)? otherwiseBuilder;

  /// The builder to run when the event is in the empty state (defaults to `defaultEmptyBuilder`)
  final Widget Function(BuildContext context, EmptyEvent<TEventState> event)? emptyBuilder;

  /// The builder to run when the event is in the waiting state (defaults to `defaultWaitingBuilder`)
  final Widget Function(BuildContext context, WaitingEvent<TEventState> event)? waitingBuilder;

  /// The builder to run when the event is in the failure state (defaults to `defaultFailureBuilder`)
  final Widget Function(BuildContext context, FailureEvent<TEventState> event)? failureBuilder;

  /// The builder to run when the event is in the success state
  final Widget Function(BuildContext context, SuccessEvent<TEventState> event)? successBuilder;

  /// This method will run if no other `on` method was provided
  final void Function(BuildContext context, Event<TEventState> event)? onOtherwise;

  /// Run this method whenever the event is empty
  final void Function(BuildContext context, EmptyEvent<TEventState> event)? onEmpty;

  /// Run this method whenever the event is waiting
  final void Function(BuildContext context, WaitingEvent<TEventState> event)? onWaiting;

  /// Run this method whenever the event is failure
  final void Function(BuildContext context, FailureEvent<TEventState> event)? onFailure;

  /// Run this method whenever the event is success
  final void Function(BuildContext context, SuccessEvent<TEventState> event)? onSuccess;

  /// Whenever the event is success, run this method to filter the event to be built
  final bool Function(TEventState value)? successFilter;

  /// If no empty builder is provided, use this (the default is a `const SizedBox`, but you can override it (usually on `main`))
  static Widget Function(BuildContext context, IEmptyEvent event) defaultEmptyBuilder = (context, event) => const SizedBox();

  /// If no waiting builder is provided, use this (the default is a `CircularProgressIndicator.adaptive`, but you can override it (usually on `main`))
  static Widget Function(BuildContext context, IWaitingEvent event) defaultWaitingBuilder = (context, event) => const Center(child: CircularProgressIndicator.adaptive());

  /// If no failure builder is provided, use this (the default is a `ErrorWidget`, but you can override it (usually on `main`))
  static Widget Function(BuildContext context, IFailureEvent event) defaultFailureBuilder = (context, event) => event.exception is FlutterError
      ? ErrorWidget.withDetails(
          message: (event.exception as FlutterError).message,
          error: event.exception as FlutterError,
        )
      : ErrorWidget(event.exception);

  @override
  Widget build(BuildContext context) {
    final stream = successFilter == null
        // ignore: invalid_use_of_protected_member
        ? Eva.getEventsStream<TEventState>(hashCode)
        // ignore: invalid_use_of_protected_member
        : Eva.getEventsStream<TEventState>(hashCode).where((event) => event is SuccessEvent<TEventState> && successFilter!(event.value));

    return StreamBuilder<Event<TEventState>>(
      initialData: initialValue == null ? Event<TEventState>.waiting() : initialValue!,
      stream: stream,
      builder: (innerContext, snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error!;
        }

        late final Event<TEventState> event;

        if (snapshot.connectionState == ConnectionState.waiting) {
          event = initialValue ?? Event<TEventState>.waiting();
        } else if (snapshot.hasData) {
          event = snapshot.data ?? Event<TEventState>.waiting();
        }

        Log.verbose(() => "${runtimeType} (${hashCode.toRadixString(16)}) is building ${event}");

        return EventState<TEventState>(
          state: event,
          child: event.match(
            empty: (e) {
              Future<void>.delayed(const Duration(milliseconds: 10)).then((_) => (onEmpty ?? onOtherwise)?.call(context, e));
              return (emptyBuilder ?? otherwiseBuilder ?? defaultEmptyBuilder)(context, e);
            },
            failure: (e) {
              Future<void>.delayed(const Duration(milliseconds: 10)).then((_) => (onFailure ?? onOtherwise)?.call(context, e));
              return (failureBuilder ?? otherwiseBuilder ?? defaultFailureBuilder)(context, e);
            },
            waiting: (e) {
              Future<void>.delayed(const Duration(milliseconds: 10)).then((_) => (onWaiting ?? onOtherwise)?.call(context, e));
              return (waitingBuilder ?? otherwiseBuilder ?? defaultWaitingBuilder)(context, e);
            },
            success: (e) {
              Future<void>.delayed(const Duration(milliseconds: 10)).then((_) => onSuccess?.call(context, e));
              return (successBuilder ?? otherwiseBuilder)!(context, e);
            },
          ),
        );
      },
    );
  }
}

/// This is an `EventBuilder<TEventState>`, but it will dispatch the `command` when the widget is
/// added to the widget tree
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

  /// The `Command` to run.
  final TCommand command;

  @override
  Widget build(context) {
    Eva.dispatchCommand(command);

    return super.build(context);
  }
}
