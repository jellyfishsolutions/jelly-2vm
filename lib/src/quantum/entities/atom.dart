import 'package:jelly_2vm/src/quantum/interfaces/persistent_storage_interface.dart';
import 'package:jelly_2vm/src/quantum/interfaces/quantum_interface.dart';

/// An [Atom] is the smallest reactive entity, you can set its `.value` and it will call `notifyListeners()`.
///
/// You can listen to its changes using `.addListener()`
class Atom<T> extends Quantum<T> {
  Atom(
    T initialValue, {
    this.persistentStorageInterface,
  }) : _value = initialValue {
    _initPersistency();
  }

  T _value;

  /// [true] if the Atom has successfully retrieved data from persistent storage, or immediately if it doesn't have one
  bool initialized = false;

  final AtomPersistentStorageInterface<T>? persistentStorageInterface;

  void _initPersistency() async {
    if (persistentStorageInterface == null) {
      initialized = true;
      notifyListeners();
      return;
    }

    if (persistentStorageInterface!.initialValueFromStorage) {
      persistentStorageInterface!.get().then((value) {
        _value = value;
        initialized = true;
        notifyListeners();
      });
    }
  }

  @override
  T get value => _value;

  set value(T v) {
    _value = v;

    persistentStorageInterface
        ?.save(v)
        .then(persistentStorageInterface!.onSaveSuccess)
        .catchError(persistentStorageInterface!.onSaveError);

    notifyListeners();
  }
}
