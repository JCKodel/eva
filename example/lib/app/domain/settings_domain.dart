import 'package:eva/eva.dart';
import '../contracts/i_app_settings_repository.dart';
import '../entities/list_to_dos_filter.dart';

/// STEP#4
/// A Domain class is a singleton class that holds all your business logic.
///
/// This class should not know anything about Flutter-related things and also
/// can only communicate with other domain classes or with repositories (but
/// ONLY using contracts in this case).
///
/// This class should be tested in your unit tests, without any kind of modification.
///
/// So, write your tests first, then your domain classes to fulfil the tests, and then
/// your real-world repositories.
///
/// Since this domain will handle Settings related actions, it requires an
/// `IAppSettingsRepository` which is kindly provided by our environment in the
/// previous steps.
///
/// In this example, all domains are const (stateless), but this is not a rule.
///
/// Since domains are singletons (i.e.: you are always working in the same instance,
/// you can save a state (for example, some API key or some global wide-app state)
@immutable
class SettingsDomain implements IDomain {
  // You don't really need to, but since the `IAppSettingsRepository` is only used
  // inside this class, then we're setting it as a private variable (otherwise, this
  // repository would be visible from other domains, which can lead to unexpected
  // results, since we don't really know what kind of `IAppSettingsRepository` was
  // intended to be injected and used elsewhere.
  //
  // So, best practice: make your injections private
  const SettingsDomain({required IAppSettingsRepository appSettingsRepository}) : _appSettingsRepository = appSettingsRepository;

  final IAppSettingsRepository _appSettingsRepository;

  //Best practice: magic strings should only be defined once and have a descriptive name
  static const String kDarkThemeSettingValue = "D";
  static const String kLightThemeSettingValue = "L";

  // Best practice: don't repeat strings (if you need to change this key name,
  // you should do the change in only one place)
  static const kBrightnessKey = "themeBrightness";

  /// Get if we should use a dark (`true`) or light (`false`) theme
  /// from the app settings.
  Future<Response<bool>> getThemeIsDark() async {
    // We get our settings from the repository...
    final setting = await _appSettingsRepository.get(kBrightnessKey);

    /// ...then map that result, meaning: if anything that is not a success
    /// (failure or empty), we return it unchanged. Just in the case of a
    /// success response, we convert it, because our repository will return
    /// a String ("D" or "L") and we need to convert it to our response
    /// requirement, which is `true` for dark mode, and `false` for light.
    return setting.map(success: (value) => Response.success(value == kDarkThemeSettingValue));
  }

  /// Saves the specified theme provided by `isDarkTheme`.
  ///
  /// Notice that we NEED to always provide a response type, so,
  /// whenever you don't need any response, create one that will
  /// at least make sense (in this case, it will return the same
  /// `isDarkTheme` provided). This is needed because it is not
  /// possible to create a non-null value for `void` and Dart
  /// is not very good at handling generics.
  Future<Response<bool>> setThemeIsDark(bool isDarkTheme) async {
    /// We just send a "D" or an "L" for our repository to be saved
    /// in the app settings
    final response = await _appSettingsRepository.set(
      kBrightnessKey,
      isDarkTheme ? kDarkThemeSettingValue : kLightThemeSettingValue,
    );

    // We don't really care about the response, but it needs to be `<bool>`
    // so we map whatever the `set` method gave us to `isDarkTheme`.
    return response.map(success: (value) => Response.success(isDarkTheme));
  }

  // Best practice: don't repeat strings (if you need to change this key name,
  // you should do the change in only one place)
  static const kListToDosFilter = "listToDosFilter";

  /// Get the last used `ListToDosFilter` or `ListToDosFilter.all` if
  /// one was never used before.
  Future<Response<ListToDosFilter>> getListToDosFilter() async {
    // This will return a String (because that's all our repository can handle)
    final setting = await _appSettingsRepository.get(kListToDosFilter);

    return setting.map(
      // On success, we try to convert the String provided by the repository to the
      // one of `ListToDosFilter` values. You don't need to worry about exceptions
      // here, because, if one happens (for example the String returned by the
      // repository doesn't exist anymore, so this code will throw an
      // `IterableElementError.noElement` exception)
      success: (value) => Response.success(ListToDosFilter.values.firstWhere((v) => v.toString() == value)),

      // If the repository says that nothing exists for the `kListToDosFilter` setting,
      // we override the empty to a default setting of `ListToDosFilter.all`.
      //
      // This is a business rule (the default to-dos list filter is `all`), so you can
      // ONLY write this here, in a Domain class.
      empty: () => const Response.success(ListToDosFilter.all),
    );
  }

  /// Saves the current `ListToDosFilter`.
  Future<Response<ListToDosFilter>> setListToDosFilter(ListToDosFilter filter) async {
    final response = await _appSettingsRepository.set(kListToDosFilter, filter.toString());

    // Same case as above: we don't really care about the response, so we just
    // map the repository response to one that makes sense here (since we NEED
    // to return something)
    return response.map(success: (value) => Response.success(filter));
  }
}
