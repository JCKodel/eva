// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'to_do_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ToDoTheme {
  bool get isDarkTheme => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ToDoThemeCopyWith<ToDoTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToDoThemeCopyWith<$Res> {
  factory $ToDoThemeCopyWith(ToDoTheme value, $Res Function(ToDoTheme) then) =
      _$ToDoThemeCopyWithImpl<$Res, ToDoTheme>;
  @useResult
  $Res call({bool isDarkTheme});
}

/// @nodoc
class _$ToDoThemeCopyWithImpl<$Res, $Val extends ToDoTheme>
    implements $ToDoThemeCopyWith<$Res> {
  _$ToDoThemeCopyWithImpl(this._value, this._then);

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
abstract class _$$_ToDoThemeCopyWith<$Res> implements $ToDoThemeCopyWith<$Res> {
  factory _$$_ToDoThemeCopyWith(
          _$_ToDoTheme value, $Res Function(_$_ToDoTheme) then) =
      __$$_ToDoThemeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isDarkTheme});
}

/// @nodoc
class __$$_ToDoThemeCopyWithImpl<$Res>
    extends _$ToDoThemeCopyWithImpl<$Res, _$_ToDoTheme>
    implements _$$_ToDoThemeCopyWith<$Res> {
  __$$_ToDoThemeCopyWithImpl(
      _$_ToDoTheme _value, $Res Function(_$_ToDoTheme) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkTheme = null,
  }) {
    return _then(_$_ToDoTheme(
      isDarkTheme: null == isDarkTheme
          ? _value.isDarkTheme
          : isDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ToDoTheme implements _ToDoTheme {
  const _$_ToDoTheme({required this.isDarkTheme});

  @override
  final bool isDarkTheme;

  @override
  String toString() {
    return 'ToDoTheme(isDarkTheme: $isDarkTheme)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ToDoTheme &&
            (identical(other.isDarkTheme, isDarkTheme) ||
                other.isDarkTheme == isDarkTheme));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isDarkTheme);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ToDoThemeCopyWith<_$_ToDoTheme> get copyWith =>
      __$$_ToDoThemeCopyWithImpl<_$_ToDoTheme>(this, _$identity);
}

abstract class _ToDoTheme implements ToDoTheme {
  const factory _ToDoTheme({required final bool isDarkTheme}) = _$_ToDoTheme;

  @override
  bool get isDarkTheme;
  @override
  @JsonKey(ignore: true)
  _$$_ToDoThemeCopyWith<_$_ToDoTheme> get copyWith =>
      throw _privateConstructorUsedError;
}
