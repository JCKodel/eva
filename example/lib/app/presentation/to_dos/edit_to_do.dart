import 'package:flutter/material.dart';

import 'package:eva/eva.dart';

import '../../commands/load_to_dos_command.dart';
import '../../commands/update_editing_to_do_command.dart';
import '../../domain/to_do_domain.dart';
import '../../entities/to_do_entity.dart';

/// STEP#12
/// This is our edit to-do page
///
/// This doesn't really need to be a stateless widget, but,
/// hey! why not?
///
/// The alternative is to build a StatefulWidget that holds
/// the title, description and completed and then just call
/// the domain to validate and save the data.
///
/// The way is done here is to actually call the domain for
/// each keystroke, running the validation and rebuilding
/// the form to show errors, etc.
class EditToDo extends StatelessWidget {
  const EditToDo({super.key});

  @override
  Widget build(BuildContext context) {
    // Since we dispatched our `EditingToDoEntity` event before
    // the code that navigates to this page, this event builder
    // will handle our events just fine
    //
    // IMPORTANT: Eva doesn't use regular streams (it uses the
    // `BehaviorSubject` of the `rxdart` package), so it really
    // doesn't matter if the `EventBuilder<T>` isn't ready yet
    // to receive events. `BehaviorSubject` will cache the
    // events and make sure that they will be ready in the future.
    return EventBuilder<EditingToDoEntity>(
      // This is an special case where the to-do doesn't
      // exist and we try to edit it
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
                    // Here we are dispatching an `UpdateEditingToDoCommand` with the same
                    // to-do entity, but with one property changed (since our entities are
                    // immutable)
                    //
                    // Mutables entities work just as well, and they are even easier (especially to
                    // check if the entity is dirty (i.e.: has non-saved changes)), but immutability
                    // will always win for maintainability in the long run.
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
                  onChanged: (value) => Eva.dispatchCommand(
                    UpdateEditingToDoCommand(editingToDo: event.value.copyWith.toDo(completed: value)),
                  ),
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

  Future<void> _saveToDo(BuildContext context, EditingToDoEntity editingToDo) async {
    // This `Eva.executeOnDomain` will call the static or top-level function
    // `_saveEditingToDoInDomain` method, passing the `editingToDo` to it
    //
    // Remember: this function will run on another thread, not here!
    //
    // Read the instructions on the `_saveEditingToDoInDomain` code!!!
    final response = await Eva.executeOnDomain(_saveEditingToDoInDomain, editingToDo);

    response.maybeMatch(
      otherwise: () {},
      success: (savingToDoEntity) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("To Do saved")));

        // Since the list of all our to-dos has changed and we don't know the
        // current filter, we'll just trigger a refresh using `LoadToDosCommand`.
        //
        // It doesn't matter that the to-dos list is in another widget, because
        // the `EventBuilder` is (or will be) listening to all events of that
        // kind, whether the widget is active or not (or even if it doesn't
        // exist yet)
        Eva.dispatchCommand(const LoadToDosCommand());
      },
      failure: (exception) {
        // Now we must do a UI business logic here because a `failure` can be
        // an exception or just a list of validation failures.
        if (exception is Iterable<ToDoValidationFailure> == false) {
          // Unexpected exception? Crash our code!
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
    // That's the reason our `EditingToDoEntity` has the original copy of our to-do
    // before edition: we need to compare the contents of the original with our current
    // edited version to determine if it is dirty (i.e.: has unsaved changes)
    final canPop = value.toDo.id == null
        ? value.toDo.title == "" && value.toDo.description == ""
        : value.toDo.title == value.originalToDo.title && value.toDo.description == value.originalToDo.description && value.toDo.completed == value.originalToDo.completed;

    // If it is not dirty, we can navigate back
    if (canPop) {
      return true;
    }

    // Otherwise, we ask the user if it wants to discard the changes

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

/// IMPORTANT!:
///
/// This method MUST be static (or outside any classes) because they must be available
/// to a separate isolate (the domain thread). Closures don't often work (if there are any
/// non-isolable classes that can't be sent to another isolate, the call will fail), so
///
/// Best practice: always make `Eva.executeOnDomain` call top-level functions.
///
/// REMEMBER: this code runs on the domain thread, not on this class or context.
///
/// You can get all your injected dependencies through the `required` parameter, just
/// like those examples.
///
/// NEVER call repositories directly! ALL YOUR CODE must be provided by some `IDomain` class!
Future<Response<ToDoEntity>> _saveEditingToDoInDomain(RequiredFactory required, PlatformInfo platform, EditingToDoEntity editingToDo) {
  return required<ToDoDomain>().saveEditingToDo(editingToDo);
}

Future<Response<int>> _deleteToDoInDomain(RequiredFactory required, PlatformInfo platform, int toDoId) async {
  return required<ToDoDomain>().deleteToDo(toDoId: toDoId);
}
