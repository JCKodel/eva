import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

@immutable
class SetEditingToDoCommand extends Command {
  const SetEditingToDoCommand({required this.toDoId});

  final int? toDoId;

  @override
  String toStringBody() {
    return "toDoId: ${toDoId}";
  }

  @override
  Stream<Event<EditingToDoEntity>> handle(required, platform) async* {
    yield const Event<EditingToDoEntity>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.startEditingToDo(toDoId);

    yield response.mapToEvent<EditingToDoEntity>();
  }
}
