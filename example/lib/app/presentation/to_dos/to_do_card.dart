import 'package:flutter/material.dart';

import 'package:eva/eva.dart';

import '../../commands/set_editing_to_do_command.dart';
import '../../commands/set_to_do_completed_command.dart';
import '../../entities/to_do_entity.dart';

import 'edit_to_do.dart';

// A to-do card.
class ToDoCard extends StatelessWidget {
  const ToDoCard({required this.toDo, super.key});

  final ToDoEntity toDo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // This EventBuilder is special, it contains the `successFilter`,
    // because it does not listen to ANY `ToDoEntity`, but only to
    // THIS `ToDoEntity` (the one with the id `todo.id`), otherwise
    // a change in this card would rebuild every other card on the app
    return EventBuilder<ToDoEntity>(
      initialValue: Event<ToDoEntity>.success(toDo),
      successFilter: (value) => value.id == toDo.id,
      successBuilder: (context, event) {
        return Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _editToDo(context, event.value.id!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.value.title,
                          style: theme.textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        event.value.creationDate.toString().split(".").first.replaceFirst(" ", "\n"),
                        style: theme.textTheme.labelSmall!.copyWith(color: theme.disabledColor),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(event.value.description, softWrap: true),
                ),
                SwitchListTile.adaptive(
                  title: Text(event.value.completed ? event.value.completionDate.toString().split(".").first : "Mark as completed"),
                  value: event.value.completed,
                  onChanged: (value) => Eva.dispatchCommand(SetToDoCompletedCommand(toDoId: event.value.id!, completed: value)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editToDo(BuildContext context, int toDoId) {
    Eva.dispatchCommand(SetEditingToDoCommand(toDoId: toDoId));
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => const EditToDo()));
  }
}
