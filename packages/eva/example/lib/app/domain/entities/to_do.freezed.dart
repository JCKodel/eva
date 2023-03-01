// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'to_do.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ToDo {
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get creationDate => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  DateTime? get completionDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ToDoCopyWith<ToDo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToDoCopyWith<$Res> {
  factory $ToDoCopyWith(ToDo value, $Res Function(ToDo) then) =
      _$ToDoCopyWithImpl<$Res, ToDo>;
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
class _$ToDoCopyWithImpl<$Res, $Val extends ToDo>
    implements $ToDoCopyWith<$Res> {
  _$ToDoCopyWithImpl(this._value, this._then);

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
abstract class _$$_ToDoCopyWith<$Res> implements $ToDoCopyWith<$Res> {
  factory _$$_ToDoCopyWith(_$_ToDo value, $Res Function(_$_ToDo) then) =
      __$$_ToDoCopyWithImpl<$Res>;
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
class __$$_ToDoCopyWithImpl<$Res> extends _$ToDoCopyWithImpl<$Res, _$_ToDo>
    implements _$$_ToDoCopyWith<$Res> {
  __$$_ToDoCopyWithImpl(_$_ToDo _value, $Res Function(_$_ToDo) _then)
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
    return _then(_$_ToDo(
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

class _$_ToDo implements _ToDo {
  const _$_ToDo(
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
    return 'ToDo(id: $id, title: $title, description: $description, creationDate: $creationDate, completed: $completed, completionDate: $completionDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ToDo &&
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
  _$$_ToDoCopyWith<_$_ToDo> get copyWith =>
      __$$_ToDoCopyWithImpl<_$_ToDo>(this, _$identity);
}

abstract class _ToDo implements ToDo {
  const factory _ToDo(
      {final int? id,
      required final String title,
      required final String description,
      required final DateTime creationDate,
      required final bool completed,
      final DateTime? completionDate}) = _$_ToDo;

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
  _$$_ToDoCopyWith<_$_ToDo> get copyWith => throw _privateConstructorUsedError;
}
