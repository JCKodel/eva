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

/// @nodoc
mixin _$EditingToDoEntity {
  ToDoEntity get toDo => throw _privateConstructorUsedError;
  ToDoEntity get originalToDo => throw _privateConstructorUsedError;
  Iterable<ToDoValidationFailure> get validationFailures =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditingToDoEntityCopyWith<EditingToDoEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditingToDoEntityCopyWith<$Res> {
  factory $EditingToDoEntityCopyWith(
          EditingToDoEntity value, $Res Function(EditingToDoEntity) then) =
      _$EditingToDoEntityCopyWithImpl<$Res, EditingToDoEntity>;
  @useResult
  $Res call(
      {ToDoEntity toDo,
      ToDoEntity originalToDo,
      Iterable<ToDoValidationFailure> validationFailures});

  $ToDoEntityCopyWith<$Res> get toDo;
  $ToDoEntityCopyWith<$Res> get originalToDo;
}

/// @nodoc
class _$EditingToDoEntityCopyWithImpl<$Res, $Val extends EditingToDoEntity>
    implements $EditingToDoEntityCopyWith<$Res> {
  _$EditingToDoEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toDo = null,
    Object? originalToDo = null,
    Object? validationFailures = null,
  }) {
    return _then(_value.copyWith(
      toDo: null == toDo
          ? _value.toDo
          : toDo // ignore: cast_nullable_to_non_nullable
              as ToDoEntity,
      originalToDo: null == originalToDo
          ? _value.originalToDo
          : originalToDo // ignore: cast_nullable_to_non_nullable
              as ToDoEntity,
      validationFailures: null == validationFailures
          ? _value.validationFailures
          : validationFailures // ignore: cast_nullable_to_non_nullable
              as Iterable<ToDoValidationFailure>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ToDoEntityCopyWith<$Res> get toDo {
    return $ToDoEntityCopyWith<$Res>(_value.toDo, (value) {
      return _then(_value.copyWith(toDo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ToDoEntityCopyWith<$Res> get originalToDo {
    return $ToDoEntityCopyWith<$Res>(_value.originalToDo, (value) {
      return _then(_value.copyWith(originalToDo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_EditingToDoEntityCopyWith<$Res>
    implements $EditingToDoEntityCopyWith<$Res> {
  factory _$$_EditingToDoEntityCopyWith(_$_EditingToDoEntity value,
          $Res Function(_$_EditingToDoEntity) then) =
      __$$_EditingToDoEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ToDoEntity toDo,
      ToDoEntity originalToDo,
      Iterable<ToDoValidationFailure> validationFailures});

  @override
  $ToDoEntityCopyWith<$Res> get toDo;
  @override
  $ToDoEntityCopyWith<$Res> get originalToDo;
}

/// @nodoc
class __$$_EditingToDoEntityCopyWithImpl<$Res>
    extends _$EditingToDoEntityCopyWithImpl<$Res, _$_EditingToDoEntity>
    implements _$$_EditingToDoEntityCopyWith<$Res> {
  __$$_EditingToDoEntityCopyWithImpl(
      _$_EditingToDoEntity _value, $Res Function(_$_EditingToDoEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toDo = null,
    Object? originalToDo = null,
    Object? validationFailures = null,
  }) {
    return _then(_$_EditingToDoEntity(
      toDo: null == toDo
          ? _value.toDo
          : toDo // ignore: cast_nullable_to_non_nullable
              as ToDoEntity,
      originalToDo: null == originalToDo
          ? _value.originalToDo
          : originalToDo // ignore: cast_nullable_to_non_nullable
              as ToDoEntity,
      validationFailures: null == validationFailures
          ? _value.validationFailures
          : validationFailures // ignore: cast_nullable_to_non_nullable
              as Iterable<ToDoValidationFailure>,
    ));
  }
}

/// @nodoc

class _$_EditingToDoEntity implements _EditingToDoEntity {
  const _$_EditingToDoEntity(
      {required this.toDo,
      required this.originalToDo,
      required this.validationFailures});

  @override
  final ToDoEntity toDo;
  @override
  final ToDoEntity originalToDo;
  @override
  final Iterable<ToDoValidationFailure> validationFailures;

  @override
  String toString() {
    return 'EditingToDoEntity(toDo: $toDo, originalToDo: $originalToDo, validationFailures: $validationFailures)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EditingToDoEntity &&
            (identical(other.toDo, toDo) || other.toDo == toDo) &&
            (identical(other.originalToDo, originalToDo) ||
                other.originalToDo == originalToDo) &&
            const DeepCollectionEquality()
                .equals(other.validationFailures, validationFailures));
  }

  @override
  int get hashCode => Object.hash(runtimeType, toDo, originalToDo,
      const DeepCollectionEquality().hash(validationFailures));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EditingToDoEntityCopyWith<_$_EditingToDoEntity> get copyWith =>
      __$$_EditingToDoEntityCopyWithImpl<_$_EditingToDoEntity>(
          this, _$identity);
}

abstract class _EditingToDoEntity implements EditingToDoEntity {
  const factory _EditingToDoEntity(
          {required final ToDoEntity toDo,
          required final ToDoEntity originalToDo,
          required final Iterable<ToDoValidationFailure> validationFailures}) =
      _$_EditingToDoEntity;

  @override
  ToDoEntity get toDo;
  @override
  ToDoEntity get originalToDo;
  @override
  Iterable<ToDoValidationFailure> get validationFailures;
  @override
  @JsonKey(ignore: true)
  _$$_EditingToDoEntityCopyWith<_$_EditingToDoEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
