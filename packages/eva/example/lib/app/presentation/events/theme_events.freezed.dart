// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LoadTheme {}

/// @nodoc
abstract class $LoadThemeCopyWith<$Res> {
  factory $LoadThemeCopyWith(LoadTheme value, $Res Function(LoadTheme) then) =
      _$LoadThemeCopyWithImpl<$Res, LoadTheme>;
}

/// @nodoc
class _$LoadThemeCopyWithImpl<$Res, $Val extends LoadTheme>
    implements $LoadThemeCopyWith<$Res> {
  _$LoadThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_LoadThemeCopyWith<$Res> {
  factory _$$_LoadThemeCopyWith(
          _$_LoadTheme value, $Res Function(_$_LoadTheme) then) =
      __$$_LoadThemeCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LoadThemeCopyWithImpl<$Res>
    extends _$LoadThemeCopyWithImpl<$Res, _$_LoadTheme>
    implements _$$_LoadThemeCopyWith<$Res> {
  __$$_LoadThemeCopyWithImpl(
      _$_LoadTheme _value, $Res Function(_$_LoadTheme) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_LoadTheme implements _LoadTheme {
  const _$_LoadTheme();

  @override
  String toString() {
    return 'LoadTheme()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_LoadTheme);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _LoadTheme implements LoadTheme {
  const factory _LoadTheme() = _$_LoadTheme;
}

/// @nodoc
mixin _$SaveTheme {
  bool get isDarkTheme => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SaveThemeCopyWith<SaveTheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveThemeCopyWith<$Res> {
  factory $SaveThemeCopyWith(SaveTheme value, $Res Function(SaveTheme) then) =
      _$SaveThemeCopyWithImpl<$Res, SaveTheme>;
  @useResult
  $Res call({bool isDarkTheme});
}

/// @nodoc
class _$SaveThemeCopyWithImpl<$Res, $Val extends SaveTheme>
    implements $SaveThemeCopyWith<$Res> {
  _$SaveThemeCopyWithImpl(this._value, this._then);

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
abstract class _$$_SaveThemeCopyWith<$Res> implements $SaveThemeCopyWith<$Res> {
  factory _$$_SaveThemeCopyWith(
          _$_SaveTheme value, $Res Function(_$_SaveTheme) then) =
      __$$_SaveThemeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isDarkTheme});
}

/// @nodoc
class __$$_SaveThemeCopyWithImpl<$Res>
    extends _$SaveThemeCopyWithImpl<$Res, _$_SaveTheme>
    implements _$$_SaveThemeCopyWith<$Res> {
  __$$_SaveThemeCopyWithImpl(
      _$_SaveTheme _value, $Res Function(_$_SaveTheme) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDarkTheme = null,
  }) {
    return _then(_$_SaveTheme(
      isDarkTheme: null == isDarkTheme
          ? _value.isDarkTheme
          : isDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SaveTheme implements _SaveTheme {
  const _$_SaveTheme({required this.isDarkTheme});

  @override
  final bool isDarkTheme;

  @override
  String toString() {
    return 'SaveTheme(isDarkTheme: $isDarkTheme)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SaveTheme &&
            (identical(other.isDarkTheme, isDarkTheme) ||
                other.isDarkTheme == isDarkTheme));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isDarkTheme);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SaveThemeCopyWith<_$_SaveTheme> get copyWith =>
      __$$_SaveThemeCopyWithImpl<_$_SaveTheme>(this, _$identity);
}

abstract class _SaveTheme implements SaveTheme {
  const factory _SaveTheme({required final bool isDarkTheme}) = _$_SaveTheme;

  @override
  bool get isDarkTheme;
  @override
  @JsonKey(ignore: true)
  _$$_SaveThemeCopyWith<_$_SaveTheme> get copyWith =>
      throw _privateConstructorUsedError;
}
