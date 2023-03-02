import 'package:isar/isar.dart';

part 'to_do.g.dart';

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
}
