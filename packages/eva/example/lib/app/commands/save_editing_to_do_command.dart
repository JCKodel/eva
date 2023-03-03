import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

@immutable
class SaveEditingToDoCommand extends Command {
  const SaveEditingToDoCommand({required this.editingToDo});

  final EditingToDoEntity editingToDo;

  @override
  String toStringBody() {
    return editingToDo.toString();
  }

  @override
  Stream<IEvent> handle(required, platform) async* {
    yield const Event<SavingToDoEntity>.waiting();

    final toDoDomain = required<ToDoDomain>();
    final response = await toDoDomain.saveEditingToDo(editingToDo);

    yield response.mapToEvent<SavingToDoEntity>();
  }
}
