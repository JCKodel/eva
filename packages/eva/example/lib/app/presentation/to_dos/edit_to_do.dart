import 'package:flutter/material.dart';

import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';

import '../../../eva/eva.dart';
import '../../commands/load_to_dos_command.dart';
import '../../commands/update_editing_to_do_command.dart';
import '../../domain/to_do_domain.dart';
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
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextFormField(
                    initialValue: event.value.toDo.title,
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
                  child: TextFormField(
                    initialValue: event.value.toDo.description,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: FilledButton.tonalIcon(
                    onPressed: () => _saveToDo(context, event.value),
                    icon: const Icon(Icons.save_alt),
                    label: const Text("SAVE"),
                  ),
                ),
                if (event.value.toDo.id != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TextButton.icon(
                      onPressed: () => _deleteToDo(context, event.value.toDo.id!),
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: const Text("DELETE", style: TextStyle(color: Colors.red)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<Response<ToDoEntity>> _saveEditingToDoInDomain(RequiredFactory required, PlatformInfo platform, EditingToDoEntity editingToDo) {
    return required<ToDoDomain>().saveEditingToDo(editingToDo);
  }

  Future<void> _saveToDo(BuildContext context, EditingToDoEntity editingToDo) async {
    final response = await Eva.executeOnDomain(_saveEditingToDoInDomain, editingToDo);

    response.maybeMatch(
      otherwise: () {},
      success: (savingToDoEntity) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("To Do saved")));
        Eva.dispatchCommand(const LoadToDosCommand());
      },
      failure: (exception) {
        if (exception is Iterable<ToDoValidationFailure> == false) {
          throw exception;
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

  static Future<Response<int>> _deleteToDoInDomain(RequiredFactory required, PlatformInfo platform, int toDoId) async {
    return required<ToDoDomain>().deleteToDo(toDoId: toDoId);
  }

  Future<void> _deleteToDo(BuildContext context, int toDoId) async {
    final canDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete to do?"),
        content: const Text("Are you sure you want to delete this to do?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Discard"),
          ),
        ],
      ),
    );

    if (canDelete == false) {
      return;
    }

    final response = await Eva.executeOnDomain(_deleteToDoInDomain, toDoId);

    response.maybeMatch(
      otherwise: () {},
      success: (id) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("To Do was deleted")));
        Eva.dispatchCommand(const LoadToDosCommand());
      },
      failure: (exception) {
        if (exception is Iterable<ToDoValidationFailure> == false) {
          throw exception;
        }
      },
    );
  }

  Future<bool> _onWillPop(BuildContext context, EditingToDoEntity value) async {
    final canPop = value.toDo.id == null
        ? value.toDo.title == "" && value.toDo.description == ""
        : value.toDo.title == value.originalToDo.title && value.toDo.description == value.originalToDo.description && value.toDo.completed == value.originalToDo.completed;

    if (canPop) {
      return true;
    }

    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Discard changes?"),
            content: const Text("Are you sure you want to discard all changes made?"),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Discard")),
            ],
          ),
        )) ??
        false;
  }
}
