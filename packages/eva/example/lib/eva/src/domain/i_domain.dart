import 'package:kfx_dependency_injection/kfx_dependency_injection.dart';
import 'package:meta/meta.dart';

/// Every domain must be decorated with this interface
///
/// It implements `IMustBeSingleton`, to ensure all domains are singletons
/// and `IInitializable`, indicating that this class must have a
/// `void initialize()` method that will be called once this domain is
/// required for the first time
///
/// But everything will work just fine without it, hey, I'm not the IDomain police!
@immutable
abstract class IDomain implements IMustBeSingleton, IInitializable {}
