import 'package:isar/isar.dart';

part 'app_setting.g.dart';

@collection
class AppSetting {
  AppSetting({
    this.id,
    required this.key,
    required this.value,
  });

  Id? id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  String key;

  String value;
}
