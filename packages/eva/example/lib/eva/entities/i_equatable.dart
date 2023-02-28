import 'package:meta/meta.dart';

@immutable
abstract class IEquatable {
  bool equals(Object other);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}
