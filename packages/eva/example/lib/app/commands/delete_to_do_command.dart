import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

@immutable
class DeleteToDoCommand extends Command {
  const DeleteToDoCommand({required this.toDoId});

  final int toDoId;

  @override
  String toStringBody() {
    return "toDoId:${toDoId}";
  }

  @override
  Stream<Event<DeletedToDoEntity>> handle(required, platform) async* {
    yield const Event<DeletedToDoEntity>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.deleteToDo(toDoId: toDoId);

    yield response.mapToEvent<DeletedToDoEntity>(success: (value) => DeletedToDoEntity(toDoId: value));
  }
}
