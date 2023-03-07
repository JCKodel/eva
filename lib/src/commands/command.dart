import '../../eva.dart';

/// This is the base class for all Commands.
@immutable
abstract class Command {
  const Command();

  /// This method will be executed in the domain isolation (thread) whenever a
  /// command of this type is dispatched
  ///
  /// IMPORTANT: this method will run on the domain thread, not on your UI thread!
  /// You cannot call anything here, except what is registered in your environments.
  ///
  /// You really should only execute code in your domain classes!
  ///
  /// Those commands exist for only one reason: to bridge and orchestrate the events
  /// between the domain thread and the UI (main) thread.
  ///
  /// IMPORTANT: the original method signature on the `Command` class is
  /// `Stream<IEvent> handle(RequiredFactory required, PlatformInfo platform)`.
  ///
  /// Notice the `Stream<IEvent>` form: it will allow you to yield any event you
  /// want, and this is completely fine if it makes sense to you, BUT, a common
  /// mistake is to yield an unexpected event type and not knowing why it didn't
  /// trigger an update in some event builder (since this type is what separates
  /// the events)
  ///
  /// So, to be safe and get errors before they happen, you can force the emission
  /// of just one kind of event by changing the signature to
  /// `Stream<Event<YourEventEntity>> handle...`, except when you really want to
  /// yield different types of events in the same handler.
  ///
  /// Best practice: always change the `handle` signature to type your yielded events.
  Stream<IEvent> handle(RequiredFactory required, PlatformInfo platform);

  @override
  String toString() {
    final body = toStringBody();

    if (body == "") {
      return "[${runtimeType}]";
    }

    return "[${runtimeType}:${body}]";
  }

  // This value will be merged with the `Command.toString()` method, returning:
  //
  // [YourCommmandClassName], when you don't override this method or
  // [YourCommandClassName:this_result], when you do override it
  //
  // Best practice: whenever your Command has an argument, override this
  // method to print it out
  String toStringBody() {
    return "";
  }
}
