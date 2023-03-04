import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

@immutable
class LoadToDoCommand extends Command {
  const LoadToDoCommand({required this.toDoId});

  final int toDoId;

  @override
  String toStringBody() {
    return "toDoId: ${toDoId}";
  }

  @override
  Stream<Event<ToDoEntity>> handle(required, platform) async* {
    yield const Event<ToDoEntity>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.loadToDo(toDoId: toDoId);

    yield response.mapToEvent<ToDoEntity>();
  }
}
