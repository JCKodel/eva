import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../eva/eva.dart';
import '../../domain/entities/to_do_theme.dart';
import '../../domain/theme_domain.dart';

part 'theme_events.freezed.dart';

@freezed
class LoadTheme with _$LoadTheme {
  const factory LoadTheme() = _LoadTheme;
}

@freezed
class SaveTheme with _$SaveTheme {
  const factory SaveTheme({required bool isDarkTheme}) = _SaveTheme;
}

@immutable
class ThemeEventHandler extends EventHandler {
  const ThemeEventHandler({required ThemeDomain themeDomain}) : _themeDomain = themeDomain;

  final ThemeDomain _themeDomain;

  @override
  Stream<IEvent> handle<TInput>(Event<TInput> event) {
    if (event is Event<LoadTheme>) {
      return _handleLoadTheme(event as SuccessEvent<LoadTheme>);
    } else if (event is Event<SaveTheme>) {
      return _handleSaveTheme(event as SuccessEvent<SaveTheme>);
    }

    throw UnimplementedError("ThemeEventHandler cannot handle ${event.runtimeType}");
  }

  Stream<IEvent> _handleLoadTheme(SuccessEvent<LoadTheme> e) async* {
    yield const Event<ToDoTheme>.waiting();

    final themeIsDark = await _themeDomain.getThemeIsDark();

    yield themeIsDark.mapToEvent(
      success: (isDarkTheme) => ToDoTheme(isDarkTheme: isDarkTheme),
    );
  }

  Stream<IEvent> _handleSaveTheme(SuccessEvent<SaveTheme> e) async* {
    final saveResult = await _themeDomain.setThemeIsDark(e.value.isDarkTheme);

    yield saveResult.mapToEvent(success: (_) => ToDoTheme(isDarkTheme: e.value.isDarkTheme));
  }
}
