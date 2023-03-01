import 'package:isar/isar.dart';

import '../../../eva/eva.dart';
import '../../contracts/i_app_settings_repository.dart';

import 'app_settings_model.dart';

class IsarAppSettingsRepository implements IAppSettingsRepository {
  IsarAppSettingsRepository();

  late final Future<Isar> _dbFuture;

  @override
  void initialize() {
    _dbFuture = Isar.open([AppSettingsModelSchema], inspector: true, name: "AppSettings");
  }

  @override
  bool get canWatch => true;

  @override
  Future<ResponseOf<String>> get(String key) async {
    final db = await _dbFuture;
    final appSetting = await db.txn(() => db.appSettingsModels.filter().keyEqualTo(key).build().findFirst());

    if (appSetting == null) {
      return const ResponseOf<String>.empty();
    }

    return ResponseOf<String>.success(appSetting.value);
  }

  @override
  Future<Response> set(String key, String value) async {
    final db = await _dbFuture;

    await db.writeTxn(() async {
      var appSetting = await db.appSettingsModels.filter().keyEqualTo(key).build().findFirst();

      if (appSetting == null) {
        appSetting = AppSettingsModel(key: key, value: value);
      } else {
        appSetting.value = value;
      }

      await db.appSettingsModels.put(appSetting);
    });

    return const Response.success();
  }

  @override
  Future<ResponseOf<Stream<String>>> watch(String key) async {
    final db = await _dbFuture;

    return ResponseOf<Stream<String>>.success(
      db.appSettingsModels
          .filter()
          .keyEqualTo(key)
          .build()
          .watch(fireImmediately: true)
          .where((appSettings) => appSettings.isNotEmpty)
          .map((appSettings) => appSettings.first.value),
    );
  }
}
