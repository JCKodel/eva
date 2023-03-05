import 'package:isar/isar.dart';

import '../../../entities/to_do_entity.dart';

part 'to_do.g.dart';

/// This is an Isar-specific class to allow us to read/write data in an Isar database
///
/// Don't rely on or return this kind of repository-specific entity to your domain/UI!
@collection
class ToDo {
  ToDo({
    this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.completed,
    this.completionDate,
  });

  Id? id = Isar.autoIncrement;

  String title;

  String description;

  @Index()
  DateTime creationDate;

  @Index()
  bool completed;

  @Index()
  DateTime? completionDate;

  ToDoEntity toEntity() {
    return ToDoEntity(
      id: id,
      title: title,
      description: description,
      completed: completed,
      creationDate: creationDate,
      completionDate: completionDate,
    );
  }
}
