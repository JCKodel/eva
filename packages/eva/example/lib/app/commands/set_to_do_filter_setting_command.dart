import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/settings_domain.dart';

@immutable
class SetToDoFilterSettingCommand extends Command {
  const SetToDoFilterSettingCommand({required this.filter});

  final ListToDosFilter filter;

  @override
  Stream<IEvent> handle(required, platformInfo) async* {
    final settingsDomain = required<SettingsDomain>();

    await settingsDomain.setListToDosFilter(filter);
    yield Event.success(filter);
  }
}
