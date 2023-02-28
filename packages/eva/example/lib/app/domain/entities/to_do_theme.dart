import 'package:freezed_annotation/freezed_annotation.dart';

part "to_do_theme.freezed.dart";

@freezed
class ToDoTheme with _$ToDoTheme {
  const factory ToDoTheme({
    required bool isDarkTheme,
  }) = _ToDoTheme;
}
