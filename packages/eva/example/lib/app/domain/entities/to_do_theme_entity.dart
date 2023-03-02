import 'package:freezed_annotation/freezed_annotation.dart';

part "to_do_theme_entity.freezed.dart";

@freezed
class ToDoThemeEntity with _$ToDoThemeEntity {
  const factory ToDoThemeEntity({
    required bool isDarkTheme,
  }) = _ToDoThemeEntity;
}
