import '../../eva/eva.dart';

@immutable
abstract class IToDoRepository implements IRepository {
  bool get canWatch;
}
