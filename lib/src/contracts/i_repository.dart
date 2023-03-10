import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';

/// Every domain must be decorated with this interface
///
/// It implements `IMustBeSingleton`, to ensure all repositories are singletons
///
/// But everything will work just fine without it, hey, I'm not the IRepository police!
abstract class IRepository implements IMustBeSingleton {}
