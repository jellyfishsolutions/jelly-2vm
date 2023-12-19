import '../../interfaces/quantum_interface.dart';

/// A [Molecule] is a reactive [Quantum] that depends on one or more [Quantum]s
///
/// The molecule will call `notifyListener()` every time any of the [Quantum]s changes
abstract class Molecule<V> extends Quantum<V> {}

/// A [Molecule] is a reactive [Quantum] that depends on one or more [Quantum]s
///
/// This molecule depends on one [Quantum]
///
/// [A] is the [Quantum] type
///
/// [V] is the type of the [Molecule] value
///
/// [map] is the mapping function that will convert the [Quantum] value into the molecule value
///
/// The molecule will call `notifyListener()` every time any of the [Quantum]s changes
class MoleculeFrom1<A, V> extends Molecule<V> {
  final V Function(A particleValue) _map;
  final Quantum<A> _quantum;

  MoleculeFrom1({
    required Quantum<A> quantum,
    required V Function(A) map,
  })  : _map = map,
        _quantum = quantum {
    _quantum.addListener(notifyListeners);
  }

  @override
  V get value => _map(_quantum.value);

  @override
  void dispose() {
    _quantum.removeListener(notifyListeners);
    super.dispose();
  }
}

/// A [Molecule] is a reactive [Quantum] that depends on one or more [Quantum]s
///
/// This molecule depends on one [Quantum]
///
/// [A] is the first [Quantum] type
///
/// [B] is the second [Quantum] type
///
/// [V] is the type of the [Molecule] value
///
/// [map] is the mapping function that will convert the [Quantum] values into the molecule value
///
/// The molecule will call `notifyListener()` every time any of the [Quantum]s changes
class MoleculeFrom2<A, B, V> extends Molecule<V> {
  final V Function(A quantumAValue, B quantumBValue) _map;
  final Quantum<A> _quantumA;
  final Quantum<B> _quantumB;

  MoleculeFrom2({
    required Quantum<A> quantumA,
    required Quantum<B> quantumB,
    required V Function(A, B) map,
  })  : _map = map,
        _quantumA = quantumA,
        _quantumB = quantumB {
    _quantumA.addListener(notifyListeners);
    _quantumB.addListener(notifyListeners);
  }

  @override
  V get value => _map(_quantumA.value, _quantumB.value);

  @override
  void dispose() {
    _quantumA.removeListener(notifyListeners);
    _quantumB.removeListener(notifyListeners);
    super.dispose();
  }
}

/// A [Molecule] is a reactive [Quantum] that depends on one or more [Quantum]s
///
/// This molecule depends on one [Quantum]
///
/// [A] is the [Quantum] type
///
/// [B] is the second [Quantum] type
///
/// [C] is the third [Quantum] type
///
/// [V] is the type of the [Molecule] value
///
/// [map] is the mapping function that will convert the [Quantum] values into the molecule value
///
/// The molecule will call `notifyListener()` every time any of the [Quantum]s changes
class MoleculeFrom3<A, B, C, V> extends Molecule<V> {
  final V Function(A quantumAValue, B quantumBValue, C quantumCValue) _map;
  final Quantum<A> _quantumA;
  final Quantum<B> _quantumB;
  final Quantum<C> _quantumC;

  MoleculeFrom3({
    required Quantum<A> quantumA,
    required Quantum<B> quantumB,
    required Quantum<C> quantumC,
    required V Function(A, B, C) map,
  })  : _map = map,
        _quantumA = quantumA,
        _quantumB = quantumB,
        _quantumC = quantumC {
    _quantumA.addListener(notifyListeners);
    _quantumB.addListener(notifyListeners);
    _quantumC.addListener(notifyListeners);
  }

  @override
  V get value => _map(_quantumA.value, _quantumB.value, _quantumC.value);

  @override
  void dispose() {
    _quantumA.removeListener(notifyListeners);
    _quantumB.removeListener(notifyListeners);
    _quantumC.removeListener(notifyListeners);
    super.dispose();
  }
}
