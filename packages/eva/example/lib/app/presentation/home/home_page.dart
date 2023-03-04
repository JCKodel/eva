import 'package:flutter/material.dart';

import '../../../eva/eva.dart';
import '../../commands/load_to_do_filter_setting_command.dart';
import '../../commands/load_to_dos_command.dart';
import '../../commands/save_theme_command.dart';
import '../../commands/set_editing_to_do_command.dart';
import '../../commands/set_to_do_filter_setting_command.dart';
import '../../entities/list_to_dos_filter.dart';
import '../../entities/to_do_theme_entity.dart';
import '../to_dos/edit_to_do.dart';
import '../to_dos/to_dos_list.dart';

/// STEP#11
/// This is the home (and only) page of the app
class HomePage extends StatelessWidget {
  /// Since we listen for events, all widgets can be stateless
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // We really could listen to `Event<ToDoThemeEntity>` and rebuild this
    // widget when the theme changes, but this causes issues with hot reloading,
    // specifically: when you save this file in your IDE, the theme reverts
    // to light theme, because the event rebuild happens on the parent widget
    // and that was not triggered by the save.
    //
    // So, for each event builder (`CommandEventBuilder` or `EventBuilder`)
    // will wrap the builder in an `InheritedWidget`, so you can get the
    // emitted event whenever you want in the context:
    final toDoThemeEntityState = EventState.of<ToDoThemeEntity>(context);

    // We dispatch a `LoadToDoFilterSettingCommand` to get the current filter state...
    return CommandEventBuilder<LoadToDoFilterSettingCommand, ListToDosFilter>(
      /// ...that will be `all` if the current filter state is empty
      initialValue: ListToDosFilter.all,
      command: const LoadToDoFilterSettingCommand(),
      successBuilder: (context, listToDosFilterEvent) {
        // Best practice: is always a good idea to cache method calls
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("EvA To Do"),
            actions: [
              // Every `Response<T>` or `Event<T>` has a `map` and `match`, so it will
              // make our 3/4 way `if` a lot easier:
              toDoThemeEntityState.state.maybeMatch(
                otherwise: (e) => _ThemeBrightnessCheckbox(isDarkTheme: WidgetsBinding.instance.window.platformBrightness == Brightness.dark),
                success: (e) => _ThemeBrightnessCheckbox(isDarkTheme: e.value.isDarkTheme),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CheckboxListTile(
                tristate: true,
                controlAffinity: ListTileControlAffinity.leading,
                secondary: IconButton(
                  icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
                  // Here we are dispatching a `LoadToDosCommand`, so Eva will
                  // call the command handler, which will call the domain, which
                  // will call the repository and give us a list of to-dos.
                  onPressed: () => Eva.dispatchCommand(const LoadToDosCommand()),
                ),
                // Our `SetToDoFilterSettingCommand` will dispatch the
                // `LoadToDosCommand`, so we don't need to repeat that
                // here
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
            onPressed: () => _openNewToDoPage(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _openNewToDoPage(BuildContext context) {
    // Since events are (truly) assynchronous, we can request the
    // to-do loading and validation even before we do the actual
    // navigation to the edit screen.
    //
    // This will reduce the total waiting time because things will start
    // to load while the navigation animation is playing, but it will
    // also may cause some stuttering when the event changes from
    // waiting to success in the middle of the animation (so Flutter will
    // rebuild a potentially heavy widget while an animation is playing)
    //
    // It's your decision to make a dispatch here or inside the `EditToDo`
    // page itself (as long it is in a place that is executed only once,
    // either an `initState` method or before any `EventBuilder<T>`).
    Eva.dispatchCommand(const SetEditingToDoCommand(toDoId: null));
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => const EditToDo()));
  }
}

class _ThemeBrightnessCheckbox extends StatelessWidget {
  const _ThemeBrightnessCheckbox({required this.isDarkTheme});

  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    return Switch(
      thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) => isDarkTheme ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
      ),
      value: isDarkTheme,
      onChanged: (newValue) => Eva.dispatchCommand(SaveThemeCommand(isDarkTheme: newValue)),
    );
  }
}
