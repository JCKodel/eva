// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'to_do_theme_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ToDoThemeEntity {
  bool get isDarkTheme => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ToDoThemeEntityCopyWith<ToDoThemeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToDoThemeEntityCopyWith<$Res> {
  factory $ToDoThemeEntityCopyWith(
          ToDoThemeEntity value, $Res Function(ToDoThemeEntity) then) =
      _$ToDoThemeEntityCopyWithImpl<$Res, ToDoThemeEntity>;
  @useResult
  $Res call({bool isDarkTheme});
}

/// @nodoc
class _$ToDoThemeEntityCopyWithImpl<$Res, $Val extends ToDoThemeEntity>
    implements $ToDoThemeEntityCopyWith<$Res> {
  _$ToDoThemeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkTheme = null,
  }) {
    return _then(_value.copyWith(
      isDarkTheme: null == isDarkTheme
          ? _value.isDarkTheme
          : isDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ToDoThemeEntityCopyWith<$Res>
    implements $ToDoThemeEntityCopyWith<$Res> {
  factory _$$_ToDoThemeEntityCopyWith(
          _$_ToDoThemeEntity value, $Res Function(_$_ToDoThemeEntity) then) =
      __$$_ToDoThemeEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isDarkTheme});
}

/// @nodoc
class __$$_ToDoThemeEntityCopyWithImpl<$Res>
    extends _$ToDoThemeEntityCopyWithImpl<$Res, _$_ToDoThemeEntity>
    implements _$$_ToDoThemeEntityCopyWith<$Res> {
  __$$_ToDoThemeEntityCopyWithImpl(
      _$_ToDoThemeEntity _value, $Res Function(_$_ToDoThemeEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkTheme = null,
  }) {
    return _then(_$_ToDoThemeEntity(
      isDarkTheme: null == isDarkTheme
          ? _value.isDarkTheme
          : isDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ToDoThemeEntity implements _ToDoThemeEntity {
  const _$_ToDoThemeEntity({required this.isDarkTheme});

  @override
  final bool isDarkTheme;

  @override
  String toString() {
    return 'ToDoThemeEntity(isDarkTheme: $isDarkTheme)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ToDoThemeEntity &&
            (identical(other.isDarkTheme, isDarkTheme) ||
                other.isDarkTheme == isDarkTheme));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isDarkTheme);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ToDoThemeEntityCopyWith<_$_ToDoThemeEntity> get copyWith =>
      __$$_ToDoThemeEntityCopyWithImpl<_$_ToDoThemeEntity>(this, _$identity);
}

abstract class _ToDoThemeEntity implements ToDoThemeEntity {
  const factory _ToDoThemeEntity({required final bool isDarkTheme}) =
      _$_ToDoThemeEntity;

  @override
  bool get isDarkTheme;
  @override
  @JsonKey(ignore: true)
  _$$_ToDoThemeEntityCopyWith<_$_ToDoThemeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
