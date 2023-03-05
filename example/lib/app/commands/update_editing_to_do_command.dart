import 'package:eva/eva.dart';
import '../domain/to_do_domain.dart';
import '../entities/to_do_entity.dart';

/// This command will be dispatched whenever an editing to-do changes
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

    // We should only do light stuff here, because, at least in this example,
    // this command is called at each and every keystroke on our form.

    yield Event.success(
      editingToDo.copyWith(validationFailures: toDoDomain.validateToDo(editingToDo.toDo)),
    );
  }
}
