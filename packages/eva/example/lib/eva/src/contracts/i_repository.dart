import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:meta/meta.dart';

@immutable
abstract class IRepository implements IMustBeSingleton, IInitializable {}
