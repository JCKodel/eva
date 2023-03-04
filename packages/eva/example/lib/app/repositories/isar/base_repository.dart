import 'package:isar/isar.dart';

import '../../../eva/eva.dart';

import 'data/app_setting.dart';
import 'data/to_do.dart';

/// STEP#9
/// This is our real-world repository (for development and production environments).
///
/// This base shared repository does actions that are common amongst all repositories
/// used in this project, so, DRY (Don't Repeat Yourself)!
@immutable
abstract class BaseRepository implements IRepository {
  @override
  Future<void> initialize() async {
    if (Isar.getInstance() == null) {
      await Isar.open(
        [AppSettingSchema, ToDoSchema],
        inspector: true,
        compactOnLaunch: const CompactCondition(minFileSize: 1024 * 1024),
      );
    }
  }
}
