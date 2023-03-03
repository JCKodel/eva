import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

@immutable
class UpdateEditingToDoCommand extends Command {
  const UpdateEditingToDoCommand({required this.editingToDo});

  final EditingToDoEntity editingToDo;

  @override
  Stream<IEvent> handle(required, platform) async* {
    final toDoDomain = required<ToDoDomain>();

    yield toDoDomain.validateToDo(editingToDo.toDo).mapToEvent<EditingToDoEntity>();
  }
}
