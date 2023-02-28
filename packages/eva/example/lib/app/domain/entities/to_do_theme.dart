import 'package:equatable/equatable.dart';

import '../../../eva/eva.dart';

@immutable
class ToDoTheme extends Equatable {
  const ToDoTheme({
    required this.isDarkTheme,
  });

  final bool isDarkTheme;

  @override
  List<Object?> get props => [isDarkTheme];
}
