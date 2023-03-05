import 'package:eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

/// This command will load all the available to-dos.
@immutable
class LoadToDosCommand extends Command {
  const LoadToDosCommand();

  @override
  Stream<Event<Iterable<ToDoEntity>>> handle(required, platform) async* {
    yield const Event<Iterable<ToDoEntity>>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.listToDos();

    yield response.mapToEvent(success: (toDos) => toDos);
  }
}
