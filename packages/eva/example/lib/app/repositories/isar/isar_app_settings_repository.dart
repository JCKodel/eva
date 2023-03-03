import 'package:isar/isar.dart';

import '../../../eva/eva.dart';
import '../../contracts/i_app_settings_repository.dart';

import 'base_repository.dart';
import 'data/app_setting.dart';

class IsarAppSettingsRepository extends BaseRepository implements IAppSettingsRepository {
  IsarAppSettingsRepository();

  @override
  Future<Response<String>> get(String key) async {
    final db = Isar.getInstance()!;
    final appSetting = await db.txn(() => db.appSettings.filter().keyEqualTo(key).build().findFirst());

    if (appSetting == null) {
      return const Response<String>.empty();
    }

    return Response.success(appSetting.value);
  }

  @override
  Future<Response<String>> set(String key, String value) async {
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
