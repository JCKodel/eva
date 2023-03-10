## 1.0.0

* Initial release

## 1.0.0+1

* Some documentation fixes

* Changed the license from GPL3 to BSD3, because people were worried they could not build a closed-source/commercial product with this framework. Now it is clear: YES, YOU CAN. =)

## 1.0.0+2

* The example to-do application is now explained step-by-step in the README.md. Documentation by example.

## 1.0.0+3

* Fixed dependencies and some typos on documentation

## 1.0.0+4

* Removed unused dependencies

## 1.0.0+5

* Update architecture graphic

## 1.0.1

* Changed the internal class `Domain` to `DomainIsolateController` to avoid confusion about what a domain class must extend (which is nothing, it must IMPLEMENT IDomain)

## 1.0.2

* Handling and executing `BackgroundIsolateBinaryMessenger.ensureInitialized()` automatically in the background isolate

## 1.0.3

* Changing the `DomainIsolateController.dispatchEvent` to be non-protected, so repositories can dispatch events without a related command
