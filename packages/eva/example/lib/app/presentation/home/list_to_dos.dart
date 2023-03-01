import 'package:flutter/material.dart';

import '../../../eva/src/presentation/event_builder.dart';
import '../../commands/load_to_do_filter_setting_command.dart';
import '../../commands/load_to_dos_command.dart';
import '../../contracts/i_to_do_repository.dart';
import '../../domain/entities/to_do.dart';

class ListToDos extends StatelessWidget {
  const ListToDos({super.key});

  @override
  Widget build(BuildContext context) {
    return CommandEventBuilder<LoadToDoFilterSettingCommand, ListToDosFilter>(
      initialValue: ListToDosFilter.all,
      command: const LoadToDoFilterSettingCommand(),
      successBuilder: (context, event) => CommandEventBuilder<LoadToDosCommand, Iterable<ToDo>>(
        command: LoadToDosCommand(filter: event.value),
        successBuilder: (context, event) => Center(
          child: Text("There are ${event.value.length} to dos on the list"),
        ),
      ),
    );
  }
}
