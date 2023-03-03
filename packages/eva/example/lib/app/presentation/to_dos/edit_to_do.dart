import 'package:flutter/material.dart';

import '../../../eva/eva.dart';
import '../../commands/save_editing_to_do_command.dart';
import '../../commands/update_editing_to_do_command.dart';
import '../../entities/to_do_entity.dart';

class EditToDo extends StatelessWidget {
  const EditToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return EventBuilder<EditingToDoEntity>(
      onEmpty: (context, event) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("To Do doesn't exist anymore!")),
        );

        Navigator.of(context).pop();
      },
      successBuilder: (context, event) => Scaffold(
        appBar: AppBar(
          title: Text("${event.value.toDo.id == null ? "New" : "Edit"} To Do"),
          actions: [
            TextButton.icon(
              onPressed: () => _saveToDo(context, event.value),
              icon: const Icon(Icons.save),
              label: const Text("Save"),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  decoration: InputDecoration(
                    label: const Text("Title"),
                    errorText: event.value.validationFailures.contains(ToDoValidationFailure.titleIsEmpty) ? "Title cannot be empty" : null,
                  ),
                  onChanged: (value) => Eva.dispatchCommand(
                    UpdateEditingToDoCommand(editingToDo: event.value.copyWith.toDo(title: value)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    label: const Text("Description"),
                    errorText: event.value.validationFailures.contains(ToDoValidationFailure.descriptionIsEmpty) ? "Description cannot be empty" : null,
                  ),
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (value) => Eva.dispatchCommand(
                    UpdateEditingToDoCommand(editingToDo: event.value.copyWith.toDo(description: value)),
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                value: event.value.toDo.completed,
                title: const Text("This to do is completed"),
                onChanged: (value) => Eva.dispatchCommand(UpdateEditingToDoCommand(editingToDo: event.value.copyWith.toDo(completed: value))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveToDo(BuildContext context, EditingToDoEntity editingToDo) async {
    final response = await Eva.dispatchCommand(SaveEditingToDoCommand(editingToDo: editingToDo)).thenWaitFor<SavingToDoEntity>();

    response.maybeMatch(
      otherwise: (e) {},
      success: (event) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("To Do saved")));
      },
      failure: (event) {
        if (event.exception is Iterable<ToDoValidationFailure> == false) {
          throw event.exception;
        }

        final theme = Theme.of(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("There are errors requiring your attention!", style: TextStyle(color: theme.colorScheme.onErrorContainer)),
            backgroundColor: theme.colorScheme.errorContainer,
          ),
        );
      },
    );
  }
}
