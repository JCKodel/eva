import 'package:eva/eva.dart';
import 'package:eva_to_do_example/app/contracts/i_app_settings_repository.dart';
import 'package:eva_to_do_example/app/domain/settings_domain.dart';
import 'package:eva_to_do_example/app/entities/list_to_dos_filter.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:kfx_dependency_injection/kfx_dependency_injection/platform_info.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_environment.dart';

/// STEP#13
/// Some unit tests examples
///
/// Notice that all domain tests have 100% coverage (check details on the test `Default getListToDosFilter`)
void main() {
  setUpAll(
    () async {
      const env = TestEnvironment();

      env.registerDependencies();
      // ignore: invalid_use_of_protected_member
      await env.initialize(ServiceProvider.required, PlatformInfo.platformInfo);
    },
  );

  group(
    "Settings Domain",
    () {
      test(
        "setThemeIsDark",
        () async {
          final settingsDomain = ServiceProvider.required<SettingsDomain>();
          final mockRepository = ServiceProvider.required<IAppSettingsRepository>();

          when(mockRepository.set(SettingsDomain.kBrightnessKey, SettingsDomain.kDarkThemeSettingValue))
              .thenAnswer((_) async => const Response<String>.success(SettingsDomain.kDarkThemeSettingValue));

          final response = await settingsDomain.setThemeIsDark(true);

          verify(mockRepository.set(SettingsDomain.kBrightnessKey, SettingsDomain.kDarkThemeSettingValue));

          response.match(
            empty: () => fail("Response should not be empty"),
            failure: (ex) => fail(ex.toString()),
            success: (value) => expect(value, true),
          );
        },
      );

      test(
        "getThemeIsDark",
        () async {
          final settingsDomain = ServiceProvider.required<SettingsDomain>();
          final mockRepository = ServiceProvider.required<IAppSettingsRepository>();

          when(mockRepository.get(SettingsDomain.kBrightnessKey)).thenAnswer((_) async => const Response<String>.success(SettingsDomain.kLightThemeSettingValue));

          final response = await settingsDomain.getThemeIsDark();

          verify(mockRepository.get(SettingsDomain.kBrightnessKey));

          response.match(
            empty: () => fail("Response should not be empty"),
            failure: (ex) => fail(ex.toString()),
            success: (value) => expect(value, false),
          );
        },
      );

      test(
        "setListToDosFilter",
        () async {
          final settingsDomain = ServiceProvider.required<SettingsDomain>();
          final mockRepository = ServiceProvider.required<IAppSettingsRepository>();

          when(mockRepository.set(SettingsDomain.kListToDosFilter, ListToDosFilter.completedOnly.toString()))
              .thenAnswer((_) async => Response<String>.success(ListToDosFilter.completedOnly.toString()));

          final response = await settingsDomain.setListToDosFilter(ListToDosFilter.completedOnly);

          verify(mockRepository.set(SettingsDomain.kListToDosFilter, ListToDosFilter.completedOnly.toString()));

          response.match(
            empty: () => fail("Response should not be empty"),
            failure: (ex) => fail(ex.toString()),
            success: (value) => expect(value, ListToDosFilter.completedOnly),
          );
        },
      );

      test(
        "getListToDosFilter",
        () async {
          final settingsDomain = ServiceProvider.required<SettingsDomain>();
          final mockRepository = ServiceProvider.required<IAppSettingsRepository>();

          when(mockRepository.get(SettingsDomain.kListToDosFilter)).thenAnswer((_) async => Response<String>.success(ListToDosFilter.uncompletedOnly.toString()));

          final response = await settingsDomain.getListToDosFilter();

          verify(mockRepository.get(SettingsDomain.kListToDosFilter));

          response.match(
            empty: () => fail("Response should not be empty"),
            failure: (ex) => fail(ex.toString()),
            success: (value) => expect(value, ListToDosFilter.uncompletedOnly),
          );
        },
      );

      test(
        "Default getListToDosFilter",
        () async {
          final settingsDomain = ServiceProvider.required<SettingsDomain>();
          final mockRepository = ServiceProvider.required<IAppSettingsRepository>();

          // This test will simulate the case when the to-dos list filter was never
          // set and then the domain business logic returns `ListToDosFilter.all`
          // for this case
          //
          // This test was possible because the extension Flutter Coverage
          // https://marketplace.visualstudio.com/items?itemName=Flutterando.flutter-coverage
          // pointed out one uncovered line in the getListToDosFilter test
          // (the one that treats that special .empty case, making it a ListToDosFilter.all)
          when(mockRepository.get(SettingsDomain.kListToDosFilter)).thenAnswer((_) async => const Response<String>.empty());

          final response = await settingsDomain.getListToDosFilter();

          verify(mockRepository.get(SettingsDomain.kListToDosFilter));

          response.match(
            empty: () => fail("Response should not be empty"),
            failure: (ex) => fail(ex.toString()),
            success: (value) => expect(value, ListToDosFilter.all),
          );
        },
      );
    },
  );
  group("To Do Domain", () {});
}
