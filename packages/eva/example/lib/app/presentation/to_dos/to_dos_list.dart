import 'package:flutter/material.dart';

import '../../../eva/src/presentation/event_builder.dart';
import '../../commands/load_to_dos_command.dart';
import '../../entities/list_to_dos_filter.dart';
import '../../entities/to_do_entity.dart';

import 'to_do_card.dart';

/// List all to-dos
class ToDosList extends StatelessWidget {
  const ToDosList({required this.listToDosFilter, super.key});

  final ListToDosFilter listToDosFilter;

  @override
  Widget build(BuildContext context) {
    return CommandEventBuilder<LoadToDosCommand, Iterable<ToDoEntity>>(
      // First we dispatch a `LoadToDosCommand` to load the to-dos
      command: const LoadToDosCommand(),
      // While we are waiting for the load, it will show the default waiting
      // widget (which is a `CircularProgressIndicator.adaptive`)
      //
      // In the case of an empty result (no to-dos), we will override the
      // default empty `SizedBox` to show a nice UI
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
      // If there is a failure, the default failure widget will render (which is a red screen of death)
      //
      // And, finally, when there are to-dos to be displayed, we just build a `ListView`
      successBuilder: (context, event) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: event.value.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: ToDoCard(toDo: event.value.elementAt(index)),
        ),
      ),
    );
  }
}
