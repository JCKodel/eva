import 'package:flutter/material.dart';

import '../../../eva/eva.dart';
import '../../commands/load_to_do_filter_setting_command.dart';
import '../../commands/save_theme_command.dart';
import '../../commands/set_to_do_filter_setting_command.dart';
import '../../entities/list_to_dos_filter.dart';
import '../../entities/to_do_theme_entity.dart';

import 'to_dos_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final toDoThemeEntityState = EventState.of<ToDoThemeEntity>(context);

    return CommandEventBuilder<LoadToDoFilterSettingCommand, ListToDosFilter>(
      initialValue: ListToDosFilter.all,
      command: const LoadToDoFilterSettingCommand(),
      successBuilder: (context, listToDosFilterEvent) => Scaffold(
        appBar: AppBar(
          title: const Text("EvA To Do"),
          actions: [
            toDoThemeEntityState.state.maybeMatch(
              otherwise: (e) => _buildThemeBrightnessCheckbox(context, WidgetsBinding.instance.window.platformBrightness == Brightness.dark),
              success: (e) => _buildThemeBrightnessCheckbox(context, e.value.isDarkTheme),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CheckboxListTile(
              tristate: true,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (newValue) => Eva.dispatchCommand(
                SetToDoFilterSettingCommand(
                  filter: newValue == null
                      ? ListToDosFilter.all
                      : newValue
                          ? ListToDosFilter.completedOnly
                          : ListToDosFilter.uncompletedOnly,
                ),
              ),
              value: listToDosFilterEvent.value == ListToDosFilter.all
                  ? null
                  : listToDosFilterEvent.value == ListToDosFilter.completedOnly
                      ? true
                      : false,
              title: Text(
                listToDosFilterEvent.value == ListToDosFilter.all
                    ? "Show all"
                    : listToDosFilterEvent.value == ListToDosFilter.completedOnly
                        ? "Show completed only"
                        : "Show uncompleted only",
              ),
            ),
          ),
        ),
        body: ToDosList(
          listToDosFilter: listToDosFilterEvent.value,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildThemeBrightnessCheckbox(BuildContext context, bool isDarkTheme) {
    return Switch.adaptive(
      value: isDarkTheme,
      onChanged: (newValue) => Eva.dispatchCommand(SaveThemeCommand(isDarkTheme: newValue)),
    );
  }
}
