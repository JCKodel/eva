import 'package:eva/eva.dart';

/// STEP#5
/// A contract is an interface (in Dart, abstract class without ANY
/// concrete code, just abstract methods and get/set accessors) that
/// says "any kind of repository implemented using this contract will
/// allow you to do these operations, no matter what kind of concrete
/// implementation it is"
///
/// This particular contract is for read/write app settings (think of
/// shared_preferences). Here we will use an Isar Database because it
/// is already used for the to-dos, so no need to use another package
/// to store user settings
///
/// These settings are basically: you are using a dark or light theme
/// and what was the last filter used in the to-do list.
///
/// Notice that all methods return a `Response<T>`. This special class
/// handles null values (`Response.empty`), exceptions (`Response.failure`)
/// and values (`Response.success`), so you never need to worry
/// about null values or exceptions and, as a bonus, you will write
/// much less `if` statements.
///
/// For example: if a setting key doesn't exist, instead of returning
/// a null String, we just return a `Response<String>.empty()`.
///
/// Check the `Response` class for more information.
@immutable
abstract class IAppSettingsRepository implements IRepository {
  /// Saves the `value` in the `key` app setting.
  Future<Response<String>> set(String key, String value);

  /// Retrieve the value saved in the specified `key`.
  Future<Response<String>> get(String key);
}
