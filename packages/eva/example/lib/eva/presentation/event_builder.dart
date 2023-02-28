import 'package:flutter/material.dart';

import '../entities/i_equatable.dart';
import '../eva.dart';
import '../events/event.dart';
import '../validation/i_validation_error.dart';

class EventBuilder<T extends IEquatable> extends StatelessWidget {
  const EventBuilder({
    required this.successBuilder,
    this.failureBuilder,
    this.validationErrorBuilder,
    this.emptyBuilder,
    this.waitingBuilder,
    this.emitOnLoad,
    this.listen,
    super.key,
  });

  final EventOf<T> Function<T>()? emitOnLoad;
  final void Function(BuildContext context, T event)? listen;
  final Widget Function(BuildContext context, T event, Object exception)? failureBuilder;
  final Widget Function(BuildContext context, T event, Iterable<IValidationError> validationErrors)? validationErrorBuilder;
  final Widget Function(BuildContext context, T event)? emptyBuilder;
  final Widget Function(BuildContext context, T event)? waitingBuilder;
  final Widget Function(BuildContext context, T event, T value) successBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventOf<T>>(
      stream: Eva.getEventStream<T>(),
      builder: (context, snapshot) {
        print(snapshot.connectionState);

        return Text(snapshot.connectionState.toString());
      },
    );
  }
}
