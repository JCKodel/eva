import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

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
    final toDoDomain = required<ToDoDomain>();
    final newToDoState = await toDoDomain.setToDoCompleted(toDoId: toDoId, completed: completed);

    yield newToDoState.mapToEvent();
  }
}
