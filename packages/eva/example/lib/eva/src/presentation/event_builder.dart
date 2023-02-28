import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

import '../eva.dart';
import '../events/event.dart';
import '../validation/i_validation_error.dart';

class EventBuilder<T extends Equatable> extends StatelessWidget {
  const EventBuilder({
    required this.successBuilder,
    super.key,
    this.emitOnLoad,
    this.emptyBuilder,
    this.failureBuilder,
    this.initialEvent,
    this.onEmpty,
    this.onFailure,
    this.onSuccess,
    this.onValidationError,
    this.onWaiting,
    this.validationErrorBuilder,
    this.waitingBuilder,
  });

  final Equatable? Function()? emitOnLoad;
  final T? initialEvent;
  final Widget Function(BuildContext context, EventOf<T> event)? emptyBuilder;
  final Widget Function(BuildContext context, EventOf<T> event)? waitingBuilder;
  final Widget Function(BuildContext context, EventOf<T> event, Iterable<IValidationError> validationErrors)? validationErrorBuilder;
  final Widget Function(BuildContext context, EventOf<T> event, Object exception)? failureBuilder;
  final Widget Function(BuildContext context, EventOf<T> event, T value) successBuilder;
  final void Function(BuildContext context, EventOf<T> event)? onEmpty;
  final void Function(BuildContext context, EventOf<T> event)? onWaiting;
  final void Function(BuildContext context, EventOf<T> event, Iterable<IValidationError> validationErrors)? onValidationError;
  final void Function(BuildContext context, EventOf<T> event, Object exception)? onFailure;
  final void Function(BuildContext context, EventOf<T> event, T value)? onSuccess;

  static Widget Function(BuildContext context, Event event) defaultEmptyBuilder = (context, event) => const SizedBox();

  static Widget Function(BuildContext context, Event event) defaultWaitingBuilder = (context, event) => const Center(child: CircularProgressIndicator.adaptive());

  static Widget Function(BuildContext context, Event event, Iterable<IValidationError> validationErrors) defaultValidationErrorBuilder =
      (context, event, validationErrors) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: validationErrors
                .map(
                  (e) => ListTile(title: Text(e.toString())),
                )
                .toList(),
          );

  static Widget Function(BuildContext context, Event event, Object exception) defaultFailureBuilder = (context, event, exception) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(title: Text(exception.toString())),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventOf<T>>(
      initialData: EventOf<T>.success(initialEvent),
      stream: Eva.getEventStream<T>(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (emitOnLoad != null) {
            final event = EventOf.success(emitOnLoad!());

            Eva.emit(event);
          }

          if (initialEvent == null) {
            final ev = EventOf<T>.waiting();

            onWaiting?.call(context, ev);
            return (waitingBuilder ?? defaultWaitingBuilder)(context, ev);
          }

          final ev = EventOf<T>.success(initialEvent);

          onSuccess?.call(context, ev, initialEvent as T);
          return successBuilder(context, ev, initialEvent as T);
        }

        if (snapshot.hasError) {
          final ev = EventOf<T>.failure(snapshot.error!);

          onFailure?.call(context, ev, snapshot.error!);
          return (failureBuilder ?? defaultFailureBuilder)(context, ev, snapshot.error!);
        }

        if (snapshot.hasData) {
          return snapshot.data!.match(
            failure: (exception) {
              onFailure?.call(context, snapshot.data!, exception);
              return (failureBuilder ?? defaultFailureBuilder)(context, snapshot.data!, exception);
            },
            validationErrors: (validationErrors) {
              onValidationError?.call(context, snapshot.data!, validationErrors);
              return (validationErrorBuilder ?? defaultValidationErrorBuilder)(context, snapshot.data!, validationErrors);
            },
            empty: () {
              onEmpty?.call(context, snapshot.data!);
              return (emptyBuilder ?? defaultEmptyBuilder)(context, snapshot.data!);
            },
            waiting: () {
              onWaiting?.call(context, snapshot.data!);
              return (waitingBuilder ?? defaultWaitingBuilder)(context, snapshot.data!);
            },
            success: (value) {
              onSuccess?.call(context, snapshot.data!, value);
              return successBuilder(context, snapshot.data!, value);
            },
          );
        }

        final ev = EventOf<T>.failure(snapshot.error!);

        onEmpty?.call(context, ev);
        return (emptyBuilder ?? defaultEmptyBuilder)(context, ev);
      },
    );
  }
}
