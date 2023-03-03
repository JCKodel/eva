import 'package:flutter/material.dart';

import '../../../eva/eva.dart';
import '../../commands/load_to_dos_command.dart';
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
      successBuilder: (context, event) => WillPopScope(
        onWillPop: () => _onWillPop(context, event.value),
        child: Scaffold(
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
      ),
    );
  }

  Future<void> _saveToDo(BuildContext context, EditingToDoEntity editingToDo) async {
    final response = await Eva.dispatchCommand(SaveEditingToDoCommand(editingToDo: editingToDo)).thenWaitFor<SavingToDoEntity>();

    response.maybeMatch(
      otherwise: (e) {},
      success: (event) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("To Do saved")));
        Eva.dispatchCommand(const LoadToDosCommand());
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

  Future<bool> _onWillPop(BuildContext context, EditingToDoEntity value) async {
    if (value.toDo.id == null) {
      bool? canPop = value.toDo.title == "" && value.toDo.description == "";

      if (canPop == true) {
        return true;
      }

      canPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Discard changes?"),
          content: const Text("Are you sure you want to discard all changes made?"),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Discard")),
          ],
        ),
      );

      return canPop ?? false;
    }

    // TODO: compare this to db
    return false;
  }
}