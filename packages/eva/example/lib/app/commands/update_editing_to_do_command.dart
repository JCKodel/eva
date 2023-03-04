import '../../eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

@immutable
class UpdateEditingToDoCommand extends Command {
  const UpdateEditingToDoCommand({required this.editingToDo});

  final EditingToDoEntity editingToDo;

  @override
  String toStringBody() {
    return editingToDo.toString();
  }

  @override
  Stream<Event<EditingToDoEntity>> handle(required, platform) async* {
    final toDoDomain = required<ToDoDomain>();

    yield Event.success(
      editingToDo.copyWith(validationFailures: toDoDomain.validateToDo(editingToDo.toDo)),
    );
  }
}
