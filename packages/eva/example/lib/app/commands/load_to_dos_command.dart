import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/entities/to_do_entity.dart';
import '../domain/to_do_domain.dart';

@immutable
class LoadToDosCommand extends Command {
  const LoadToDosCommand({required this.filter});

  final ListToDosFilter filter;

  @override
  Stream<IEvent> handle(required, platformInfo) async* {
    yield const Event<List<ToDoEntity>>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.listToDos(filter);

    yield response.mapToEvent(success: (toDos) => toDos);
  }
}
