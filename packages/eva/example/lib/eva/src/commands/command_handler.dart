import '../../eva.dart';

@immutable
abstract class ICommandHandler {}

@immutable
abstract class CommandHandler<T extends Command> implements ICommandHandler {
  const CommandHandler();

  Stream<IEvent> handle(T command);
}
