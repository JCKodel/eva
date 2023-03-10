import 'package:eva/eva.dart';
import 'package:isar/isar.dart';

import '../../contracts/i_to_do_repository.dart';
import '../../entities/list_to_dos_filter.dart';
import '../../entities/to_do_entity.dart';
import 'base_repository.dart';
import 'data/to_do.dart';

class IsarToDoRepository extends BaseRepository implements IToDoRepository {
  IsarToDoRepository();

  // Since we're dealing with a local database, a cache will never hurt us!
  final _cache = <int, ToDoEntity>{};

  @override
  Future<Response<Iterable<ToDoEntity>>> listToDos(ListToDosFilter filter) async {
    // No cache here =(

    final db = await dbInstance;

    return db.txn(() async {
      late final List<ToDo> toDos;

      switch (filter) {
        case ListToDosFilter.all:
          toDos = await db.toDos.where().sortByCompletionDate().thenByTitle().findAll();
          break;
        case ListToDosFilter.completedOnly:
          toDos = await db.toDos.filter().completedEqualTo(true).sortByTitle().build().findAll();
          break;
        case ListToDosFilter.uncompletedOnly:
          toDos = await db.toDos.filter().completedEqualTo(false).sortByCompletionDateDesc().thenByTitle().build().findAll();
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
    final cachedValue = _cache[id];

    if (cachedValue != null) {
      // Since a `Response.success(null)` is converted to `Response.empty()`
      // no extra checks are needed here
      return Response.success(cachedValue);
    }

    final db = await dbInstance;

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

        final savedToDo = toDo.copyWith(id: id);

        _cache[id] = savedToDo;

        return Response.success(savedToDo);
      },
    );
  }

  @override
  Future<Response<bool>> deleteToDoById(int toDoId) async {
    final db = await dbInstance;
    final deleted = await db.writeTxn(() => db.toDos.delete(toDoId));

    _cache.remove(toDoId);

    return Response.success(deleted);
  }
}
