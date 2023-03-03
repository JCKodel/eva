import 'package:flutter/material.dart';

import '../../../eva/eva.dart';
import '../../commands/set_to_do_completed_command.dart';
import '../../entities/to_do_entity.dart';

class ToDoCard extends StatelessWidget {
  const ToDoCard({required this.toDo, super.key});

  final ToDoEntity toDo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EventBuilder<ToDoEntity>(
      initialValue: toDo,
      successFilter: (value) => value.id == toDo.id,
      successBuilder: (context, event) {
        return Card(
          margin: EdgeInsets.zero,
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
        );
      },
    );
  }
}
