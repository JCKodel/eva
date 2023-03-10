import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';

/// Every domain must be decorated with this interface
///
/// It implements `IMustBeSingleton`, to ensure all domains are singletons
///
/// But everything will work just fine without it, hey, I'm not the IDomain police!
abstract class IDomain implements IMustBeSingleton {}
