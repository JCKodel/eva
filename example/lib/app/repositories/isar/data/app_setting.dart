import 'package:isar/isar.dart';

part 'app_setting.g.dart';

/// This is an Isar-specific class to allow us to read/write data in an Isar database
///
/// Don't rely on or return this kind of repository-specific entity to your domain/UI!
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
