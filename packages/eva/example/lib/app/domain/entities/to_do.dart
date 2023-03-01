import 'package:freezed_annotation/freezed_annotation.dart';

part "to_do.freezed.dart";

@freezed
class ToDo with _$ToDo {
  const factory ToDo({
    int? id,
    required String title,
    required String description,
    required DateTime creationDate,
    required bool completed,
    DateTime? completionDate,
  }) = _ToDo;
}
