import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';

@immutable
class DeleteToDoCommand extends Command {
  const DeleteToDoCommand({required this.toDoId});

  final int toDoId;

  @override
  String toStringBody() {
    return "toDoId:${toDoId}";
  }

  @override
  Stream<Event<int>> handle(required, platform) async* {
    yield const Event<int>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.deleteToDo(toDoId: toDoId);

    yield response.mapToEvent(success: (value) => value);
  }
}
