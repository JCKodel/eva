import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

@immutable
class LoadToDosCommand extends Command {
  const LoadToDosCommand();

  @override
  Stream<IEvent> handle(required, platform) async* {
    yield const Event<List<ToDoEntity>>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.listToDos();

    yield response.mapToEvent(success: (toDos) => toDos);
  }
}
