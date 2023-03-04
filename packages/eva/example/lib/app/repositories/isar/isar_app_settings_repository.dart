import 'package:isar/isar.dart';

import '../../../eva/eva.dart';
import '../../contracts/i_app_settings_repository.dart';

import 'base_repository.dart';
import 'data/app_setting.dart';

/// This is an implementation of `IAppSettingsRepository`, using the Isar database
/// (check their package in pub.dev)
class IsarAppSettingsRepository extends BaseRepository implements IAppSettingsRepository {
  IsarAppSettingsRepository();

  // Since we're dealing with a local database, a cache will never hurt us!
  final _cache = <String, String>{};

  @override
  Future<Response<String>> get(String key) async {
    final cachedValue = _cache[key];

    if (cachedValue != null) {
      // Since a `Response.success(null)` is converted to `Response.empty()`
      // no extra checks are needed here
      return Response.success(cachedValue);
    }

    final db = Isar.getInstance()!;
    final appSetting = await db.txn(() => db.appSettings.filter().keyEqualTo(key).build().findFirst());

    if (appSetting == null) {
      return const Response<String>.empty();
    }

    return Response.success(appSetting.value);
  }

  @override
  Future<Response<String>> set(String key, String value) async {
    _cache[key] = value;

    final db = Isar.getInstance()!;

    await db.writeTxn(() async {
      var appSetting = await db.appSettings.filter().keyEqualTo(key).build().findFirst();

      if (appSetting == null) {
        appSetting = AppSetting(key: key, value: value);
      } else {
        appSetting.value = value;
      }

      await db.appSettings.put(appSetting);
    });

    return Response.success(value);
  }
}
