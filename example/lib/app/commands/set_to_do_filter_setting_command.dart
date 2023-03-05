import 'package:eva/eva.dart';
import '../domain/settings_domain.dart';
import '../entities/list_to_dos_filter.dart';

/// This command will save the new state of to-do list filter and
/// emit the `ListToDosFilter` event to reload them using the new
/// filter
@immutable
class SetToDoFilterSettingCommand extends Command {
  const SetToDoFilterSettingCommand({required this.filter});

  final ListToDosFilter filter;

  @override
  String toStringBody() {
    return "filter: ${filter}";
  }

  @override
  Stream<Event<ListToDosFilter>> handle(required, platform) async* {
    yield const Event.waiting();

    final settingsDomain = required<SettingsDomain>();

    await settingsDomain.setListToDosFilter(filter);
    yield Event.success(filter);
  }
}
