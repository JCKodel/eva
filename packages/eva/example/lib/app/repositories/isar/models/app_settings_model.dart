import 'package:isar/isar.dart';

part 'app_settings_model.g.dart';

@collection
class AppSettingsModel {
  AppSettingsModel({required this.key, required this.value, this.id});

  Id? id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  String key;

  String value;
}
