import 'package:isar/isar.dart';

import '../../../eva/eva.dart';

import 'data/app_setting.dart';
import 'data/to_do.dart';

@immutable
abstract class BaseRepository implements IRepository {
  @override
  void initialize() {
    Isar.openSync(
      [AppSettingSchema, ToDoSchema],
      inspector: true,
      compactOnLaunch: const CompactCondition(minFileSize: 1024 * 1024),
    );
  }
}