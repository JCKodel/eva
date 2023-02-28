import 'package:meta/meta.dart';

import '../../eva/entities/i_equatable.dart';

@immutable
class ToDoTheme implements IEquatable {
  const ToDoTheme({
    required this.colorSwatch,
    required this.isDarkTheme,
  });

  final int colorSwatch;
  final bool isDarkTheme;

  ToDoTheme copyWith({
    int? colorSwatch,
    bool? isDarkTheme,
  }) {
    return ToDoTheme(
      colorSwatch: colorSwatch ?? this.colorSwatch,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "colorSwatch": colorSwatch,
      "isDarkTheme": isDarkTheme,
    };
  }

  static ToDoTheme fromMap(dynamic map) {
    return ToDoTheme(
      colorSwatch: (map['colorSwatch'] as int?) ?? 0,
      isDarkTheme: (map['isDarkTheme'] as bool?) ?? false,
    );
  }

  @override
  String toString() => 'ToDoTheme(colorSwatch: $colorSwatch, isDarkTheme: $isDarkTheme)';

  @override
  bool operator ==(Object other) {
    if (other is IEquatable == false) {
      return false;
    }

    if (identical(this, other)) {
      return true;
    }

    return other is ToDoTheme && other.colorSwatch == colorSwatch && other.isDarkTheme == isDarkTheme;
  }

  @override
  bool equals(Object other) {
    return other == this;
  }

  @override
  int get hashCode => colorSwatch.hashCode ^ isDarkTheme.hashCode;
}
