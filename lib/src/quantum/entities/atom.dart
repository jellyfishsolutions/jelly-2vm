import 'package:jelly_2vm/src/quantum/interfaces/quantum_interface.dart';

/// An [Atom] is the smallest reactive entity, you can set its `.value` and it will call `notifyListeners()`.
///
/// You can listen to its changes using `.addListener()`
class Atom<T> extends Quantum<T> {
  Atom(T initialValue) : _value = initialValue;

  T _value;

  @override
  T get value => _value;

  set value(T v) {
    _value = v;
    notifyListeners();
  }
}
