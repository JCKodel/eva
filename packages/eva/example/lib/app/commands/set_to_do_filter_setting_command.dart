import '../../eva/eva.dart';
import '../domain/settings_domain.dart';
import '../entities/list_to_dos_filter.dart';

@immutable
class SetToDoFilterSettingCommand extends Command {
  const SetToDoFilterSettingCommand({required this.filter});

  final ListToDosFilter filter;

  @override
  Stream<IEvent> handle(required, platform) async* {
    final settingsDomain = required<SettingsDomain>();

    await settingsDomain.setListToDosFilter(filter);
    yield Event.success(filter);
  }
}
