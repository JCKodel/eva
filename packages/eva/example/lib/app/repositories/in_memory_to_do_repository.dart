import 'package:eva_to_do_example/app/contracts/i_to_do_repository.dart';

import '../../eva/eva.dart';

@immutable
class InMemoryToDoRepository implements IToDoRepository {
  const InMemoryToDoRepository();

  @override
  bool get canWatch => false;

  @override
  void initialize() {}
}
