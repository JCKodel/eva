import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

/// This command handles the completion switch toggle in the to-do list.
@immutable
class SetToDoCompletedCommand extends Command {
  const SetToDoCompletedCommand({required this.toDoId, required this.completed});

  final int toDoId;
  final bool completed;

  @override
  String toStringBody() {
    return "toDoId: ${toDoId}, completed: ${completed}";
  }

  @override
  Stream<Event<ToDoEntity>> handle(required, platform) async* {
    // Since we don't want any kind of rebuild while waiting for this response,
    // we're not yielding a `waiting` here
    final toDoDomain = required<ToDoDomain>();
    final newToDoState = await toDoDomain.setToDoCompleted(toDoId: toDoId, completed: completed);

    yield newToDoState.mapToEvent();
  }
}
