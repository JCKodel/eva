import 'package:eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

/// This command is dispatch when a to-do is starting to be edited,
/// so it will be loaded from the database (edit only) and it will
/// be validated.
///
/// The UI page that handles to-do edition will then listen for events
/// of `EditingToDoEntity` (yes, you can trigger a database load even
/// before navigating to the page that will handle that data!)
@immutable
class SetEditingToDoCommand extends Command {
  const SetEditingToDoCommand({required this.toDoId});

  final int? toDoId;

  // This is not actually required, but when using the verbose log setting,
  // this will output the value of `toDoId` in the log, so it might be useful
  // to debug your code.
  //
  // This value will be merged with the `Command.toString()` method, returning:
  //
  // [YourCommmandClassName], when you don't override this method or
  // [YourCommandClassName:this_result], when you do override it
  @override
  String toStringBody() {
    return "toDoId: ${toDoId}";
  }

  @override
  Stream<Event<EditingToDoEntity>> handle(required, platform) async* {
    // Not sure if waiting is needed, but, it won't hurt to yield it
    // and let the UI figure out if we need to show some progress
    // indicator or not in this case
    //
    // Best practice: always yield `waiting` and let the UI do the
    // decision on how to handle it (except if you really don't want
    // to show any kind of progress indicator in the UI, even the one
    // provided by default by the event builders)
    yield const Event<EditingToDoEntity>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.startEditingToDo(toDoId);

    yield response.mapToEvent<EditingToDoEntity>();
  }
}
