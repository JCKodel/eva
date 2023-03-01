import '../../eva/eva.dart';
import '../contracts/i_to_do_repository.dart';
import '../domain/settings_domain.dart';

@immutable
class LoadToDoFilterSettingCommand extends Command {
  const LoadToDoFilterSettingCommand();
}

@immutable
class LoadToDoFilterSettingCommandHandler extends CommandHandler<LoadToDoFilterSettingCommand> {
  const LoadToDoFilterSettingCommandHandler({required SettingsDomain settingsDomain}) : _settingsDomain = settingsDomain;

  final SettingsDomain _settingsDomain;

  @override
  Stream<IEvent> handle(LoadToDoFilterSettingCommand command) async* {
    yield const Event<ListToDosFilter>.waiting();

    if (_settingsDomain.canWatchSetingsChanges) {
      final watcherResponse = await _settingsDomain.setupListToDosFilterWatcher();

      if (watcherResponse.type != ResponseType.success) {
        yield await _loadListToDosFilter(command);
      } else {
        final stream = watcherResponse.getValue();

        if (await stream.isEmpty) {
          yield await _loadListToDosFilter(command);
        } else {
          yield* watcherResponse.getValue().map((filter) => Event<ListToDosFilter>.success(filter));
        }
      }
    } else {
      yield await _loadListToDosFilter(command);
    }
  }

  Future<IEvent> _loadListToDosFilter(LoadToDoFilterSettingCommand command) async {
    final response = await _settingsDomain.getListToDosFilter();

    return response.mapToEvent(
      success: (filter) => filter,
    );
  }
}
