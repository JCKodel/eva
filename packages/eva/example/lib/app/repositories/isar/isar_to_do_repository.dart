import 'package:isar/isar.dart';

import '../../../eva/eva.dart';
import '../../contracts/i_to_do_repository.dart';
import '../../domain/entities/to_do_entity.dart';

import 'base_repository.dart';
import 'data/to_do.dart';

class IsarToDoRepository extends BaseRepository implements IToDoRepository {
  IsarToDoRepository();

  @override
  bool get canWatch => true;

  @override
  Future<ResponseOf<Stream<Iterable<ToDoEntity>>>> watch() async {
    final db = Isar.getInstance()!;

    return ResponseOf.success(
      db.toDos.where().watch(fireImmediately: true).cast<Iterable<ToDoEntity>>(),
    );
  }

  @override
  Future<ResponseOf<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter) async {
    final db = Isar.getInstance()!;

    return db.txn(() async {
      late final List<ToDo> toDos;

      switch (filter) {
        case ListToDosFilter.all:
          toDos = await db.toDos.where().findAll();
          break;
        case ListToDosFilter.completedOnly:
          toDos = await db.toDos.filter().completedEqualTo(true).build().findAll();
          break;
        case ListToDosFilter.uncompletedOnly:
          toDos = await db.toDos.filter().completedEqualTo(false).build().findAll();
          break;
      }

      if (toDos.isEmpty) {
        return const ResponseOf<Iterable<ToDoEntity>>.empty();
      }

      return ResponseOf.success(
        toDos.map(
          (toDo) => ToDoEntity(
            id: toDo.id,
            title: toDo.title,
            description: toDo.description,
            completed: toDo.completed,
            creationDate: toDo.creationDate,
            completionDate: toDo.completionDate,
          ),
        ),
      );
    });
  }
}
