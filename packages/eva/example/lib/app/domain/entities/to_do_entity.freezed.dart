// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'to_do_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ToDoEntity {
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get creationDate => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  DateTime? get completionDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ToDoEntityCopyWith<ToDoEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToDoEntityCopyWith<$Res> {
  factory $ToDoEntityCopyWith(
          ToDoEntity value, $Res Function(ToDoEntity) then) =
      _$ToDoEntityCopyWithImpl<$Res, ToDoEntity>;
  @useResult
  $Res call(
      {int? id,
      String title,
      String description,
      DateTime creationDate,
      bool completed,
      DateTime? completionDate});
}

/// @nodoc
class _$ToDoEntityCopyWithImpl<$Res, $Val extends ToDoEntity>
    implements $ToDoEntityCopyWith<$Res> {
  _$ToDoEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = null,
    Object? creationDate = null,
    Object? completed = null,
    Object? completionDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      creationDate: null == creationDate
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      completionDate: freezed == completionDate
          ? _value.completionDate
          : completionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ToDoEntityCopyWith<$Res>
    implements $ToDoEntityCopyWith<$Res> {
  factory _$$_ToDoEntityCopyWith(
          _$_ToDoEntity value, $Res Function(_$_ToDoEntity) then) =
      __$$_ToDoEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String title,
      String description,
      DateTime creationDate,
      bool completed,
      DateTime? completionDate});
}

/// @nodoc
class __$$_ToDoEntityCopyWithImpl<$Res>
    extends _$ToDoEntityCopyWithImpl<$Res, _$_ToDoEntity>
    implements _$$_ToDoEntityCopyWith<$Res> {
  __$$_ToDoEntityCopyWithImpl(
      _$_ToDoEntity _value, $Res Function(_$_ToDoEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = null,
    Object? creationDate = null,
    Object? completed = null,
    Object? completionDate = freezed,
  }) {
    return _then(_$_ToDoEntity(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      creationDate: null == creationDate
          ? _value.creationDate
          : creationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      completionDate: freezed == completionDate
          ? _value.completionDate
          : completionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_ToDoEntity implements _ToDoEntity {
  const _$_ToDoEntity(
      {this.id,
      required this.title,
      required this.description,
      required this.creationDate,
      required this.completed,
      this.completionDate});

  @override
  final int? id;
  @override
  final String title;
  @override
  final String description;
  @override
  final DateTime creationDate;
  @override
  final bool completed;
  @override
  final DateTime? completionDate;

  @override
  String toString() {
    return 'ToDoEntity(id: $id, title: $title, description: $description, creationDate: $creationDate, completed: $completed, completionDate: $completionDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ToDoEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.creationDate, creationDate) ||
                other.creationDate == creationDate) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.completionDate, completionDate) ||
                other.completionDate == completionDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      creationDate, completed, completionDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ToDoEntityCopyWith<_$_ToDoEntity> get copyWith =>
      __$$_ToDoEntityCopyWithImpl<_$_ToDoEntity>(this, _$identity);
}

abstract class _ToDoEntity implements ToDoEntity {
  const factory _ToDoEntity(
      {final int? id,
      required final String title,
      required final String description,
      required final DateTime creationDate,
      required final bool completed,
      final DateTime? completionDate}) = _$_ToDoEntity;

  @override
  int? get id;
  @override
  String get title;
  @override
  String get description;
  @override
  DateTime get creationDate;
  @override
  bool get completed;
  @override
  DateTime? get completionDate;
  @override
  @JsonKey(ignore: true)
  _$$_ToDoEntityCopyWith<_$_ToDoEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
