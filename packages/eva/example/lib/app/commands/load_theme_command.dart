import '../../eva/eva.dart';
import '../domain/settings_domain.dart';
import '../entities/to_do_theme_entity.dart';

/// STEP#8
/// Commands are messages sent from the main thread to the domain thread.
///
/// This command will be dispatched whenever we need to load the current
/// app theme (this will be dispatched by a `CommandEventBuilder<LoadThemeCommand, ToDoThemeEntity>`
/// widget that wraps the whole app)
///
/// Commands are instantiated when needed, so they are stateless
@immutable
class LoadThemeCommand extends Command {
  const LoadThemeCommand();

  /// This will handle the command (what will happen when this command is dispatched)
  ///
  /// IMPORTANT: this method will run on the domain thread, not on your UI thread!
  /// You cannot call anything here, except what is registered in your environments.
  ///
  /// Those methods exist for only one reason: to bridge and orchestrate the events
  /// between the domain thread and the UI (main) thread.
  ///
  /// IMPORTANT: the original method signature on the `Command` class is
  /// `Stream<IEvent> handle(RequiredFactory required, PlatformInfo platform)`.
  ///
  /// Notice the `Stream<IEvent>` form: it will allow you to yield any event you
  /// want, and this is completely fine if it makes sense to you, BUT, a common
  /// mistake observed while this app was being built is that sometimes we copy
  /// and paste code and forget to change things (in this particular case, I was
  /// firing (yielding) an event that was not related to what I wanted, because of
  /// the copy-paste, making my UI change to a waiting state of another event
  /// that would never trigger by this handler)
  ///
  /// So, to be safe and get errors before they happen, you can force the emission
  /// of just one kind of event by changing the signature to
  /// `Stream<Event<YourEventEntity>> handle...`, so the that observed mistake was
  /// not even possible anymore.
  ///
  /// Best practice: always change the `handle` signature to type your yielded events.
  @override
  Stream<Event<ToDoThemeEntity>> handle(required, platform) async* {
    // This works just like a BLoC pattern: this method is `async*`,
    // meaning it returns a stream of results.
    //
    // Our first result is a `waiting`, so the UI can show a widget
    // such as CircularProgressIndicator.
    //
    // Notice that since we changed our signature, Dart will be able to
    // infer that `Event.waiting()` is actually `Event<ToDoThemeEntity>.waiting()`.
    //
    // This is very important, because, without the proper analysis_options.yaml,
    // no warning will be issued if you try to create an `Event.waiting()` inside
    // a untyped method (`Event.waiting()` is `Event<dynamic>.waiting()`, but your
    // UI is specifically waiting for a `ToDoThemeEntity` event).
    //
    // If you don't mind the verbosity, always implicitly type your generic references
    // (`Event<ToDoThemeEntity>.waiting()`), so you get nice compilation errors.
    yield const Event.waiting();

    // You can get all types registered in the environment by using the `required` factory:
    final settingsDomain = required<SettingsDomain>();

    // Always call your domain and let it do all the business logic
    // (remember: a Command is only an orchestrator of events)
    final response = await settingsDomain.getThemeIsDark();

    // Since domains use `Response<T>` and commands use `Event<T>`, all responses have
    // this neat method to convert it to an event:
    yield response.mapToEvent(success: (isDarkTheme) => ToDoThemeEntity(isDarkTheme: isDarkTheme));
  }
}
