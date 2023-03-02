import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/list_to_dos_filter.dart';
import '../entities/to_do_entity.dart';

@immutable
class LoadToDosCommand extends Command {
  const LoadToDosCommand({required this.filter});

  final ListToDosFilter filter;

  @override
  Stream<IEvent> handle(required, platform) async* {
    yield const Event<List<ToDoEntity>>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.listToDos(filter);

    yield response.mapToEvent(success: (toDos) => toDos);
  }
}
