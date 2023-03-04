import '../../eva/eva.dart';
import '../domain/settings_domain.dart';
import '../entities/list_to_dos_filter.dart';

/// This command will load the current `ListToDosFilter`.
@immutable
class LoadToDoFilterSettingCommand extends Command {
  const LoadToDoFilterSettingCommand();

  @override
  Stream<Event<ListToDosFilter>> handle(required, platform) async* {
    yield const Event<ListToDosFilter>.waiting();

    final settingsDomain = required<SettingsDomain>();
    final response = await settingsDomain.getListToDosFilter();

    yield response.mapToEvent(success: (filter) => filter);
  }
}
