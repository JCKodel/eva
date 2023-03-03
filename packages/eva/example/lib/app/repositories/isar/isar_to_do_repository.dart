import 'package:isar/isar.dart';

import '../../../eva/eva.dart';
import '../../contracts/i_to_do_repository.dart';
import '../../entities/list_to_dos_filter.dart';
import '../../entities/to_do_entity.dart';

import 'base_repository.dart';
import 'data/to_do.dart';

class IsarToDoRepository extends BaseRepository implements IToDoRepository {
  IsarToDoRepository();

  @override
  Future<Response<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter) async {
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
        return const Response<Iterable<ToDoEntity>>.empty();
      }

      return Response.success(toDos.map((toDo) => toDo.toEntity()));
    });
  }

  @override
  Future<Response<ToDoEntity>> getToDoById(int id) async {
    final db = Isar.getInstance()!;

    return db.txn(() async {
      final toDo = await db.toDos.get(id);

      if (toDo == null) {
        return const Response.empty();
      }

      return Response.success(toDo.toEntity());
    });
  }

  @override
  Future<Response<ToDoEntity>> saveToDo(ToDoEntity toDo) async {
    final db = Isar.getInstance()!;

    return db.writeTxn(
      () async {
        final id = await db.toDos.put(
          ToDo(
            id: toDo.id,
            title: toDo.title,
            description: toDo.description,
            completed: toDo.completed,
            creationDate: toDo.creationDate,
            completionDate: toDo.completionDate,
          ),
        );

        return Response.success(toDo.copyWith(id: id));
      },
    );
  }

  @override
  Future<Response<bool>> deleteToDoById(int toDoId) async {
    final db = Isar.getInstance()!;
    final deleted = await db.writeTxn(() => db.toDos.delete(toDoId));

    return Response.success(deleted);
  }
}
