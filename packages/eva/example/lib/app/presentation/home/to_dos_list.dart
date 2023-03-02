import 'package:flutter/material.dart';

import '../../../eva/src/presentation/event_builder.dart';
import '../../commands/load_to_dos_command.dart';
import '../../entities/list_to_dos_filter.dart';
import '../../entities/to_do_entity.dart';

class ToDosList extends StatelessWidget {
  const ToDosList({required this.listToDosFilter, super.key});

  final ListToDosFilter listToDosFilter;

  @override
  Widget build(BuildContext context) {
    return CommandEventBuilder<LoadToDosCommand, Iterable<ToDoEntity>>(
      command: LoadToDosCommand(filter: listToDosFilter),
      emptyBuilder: (context, event) {
        final theme = Theme.of(context);

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 64, color: theme.disabledColor),
              const SizedBox.square(dimension: 16),
              Text(
                "You don't have any to do!\n"
                "Use the button + to create one",
                style: TextStyle(color: theme.disabledColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
      successBuilder: (context, event) => Center(
        child: Text("There are ${event.value.length} to dos on the list"),
      ),
    );
  }
}
