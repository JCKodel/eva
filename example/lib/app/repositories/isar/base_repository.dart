import 'package:eva/eva.dart';
import 'package:isar/isar.dart';

import 'data/app_setting.dart';
import 'data/to_do.dart';

/// STEP#9
/// This is our real-world repository (for development and production environments).
///
/// This base shared repository does actions that are common amongst all repositories
/// used in this project, so, DRY (Don't Repeat Yourself)!
///
/// In this example, all repositories are const (stateless), but you can
/// make them stateful, if you wish (just keep in mind that those classes
/// are singleton, i.e.: they are instantiated only once)
///
/// A usefull stateful information in a repository is some API key or OAuth token
/// that is used throughout the app life-cycle.
abstract class BaseRepository implements IRepository {
  Future<Isar> get dbInstance async {
    if (Isar.getInstance() == null) {
      await Isar.open(
        [AppSettingSchema, ToDoSchema],
        inspector: true,
        compactOnLaunch: const CompactCondition(minFileSize: 1024 * 1024),
      );
    }

    return Isar.getInstance()!;
  }
}
