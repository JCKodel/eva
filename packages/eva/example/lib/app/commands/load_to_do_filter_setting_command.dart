import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/settings_domain.dart';

@immutable
class LoadToDoFilterSettingCommand extends Command {
  const LoadToDoFilterSettingCommand();

  @override
  Stream<IEvent> handle(required, platformInfo) async* {
    yield const Event<ListToDosFilter>.waiting();

    final settingsDomain = required<SettingsDomain>();
    final response = await settingsDomain.getListToDosFilter();

    yield response.mapToEvent(success: (filter) => filter);
  }
}
