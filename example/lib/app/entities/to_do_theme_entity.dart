import 'package:freezed_annotation/freezed_annotation.dart';

part "to_do_theme_entity.freezed.dart";

/// Events must have a unique type and those types should mean
/// something, so, instead of just listening to an `Event<bool>`
/// to change light/dark theme, we wrap that toggle inside
/// this class.
@freezed
class ToDoThemeEntity with _$ToDoThemeEntity {
  const factory ToDoThemeEntity({
    /// Theme is dark.
    required bool isDarkTheme,
  }) = _ToDoThemeEntity;
}
