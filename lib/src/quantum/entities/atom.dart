import 'package:jelly_2vm/src/quantum/interfaces/persistent_storage_interface.dart';
import 'package:jelly_2vm/src/quantum/interfaces/quantum_interface.dart';

/// An [Atom] is the smallest reactive entity, you can set its `.value` and it will call `notifyListeners()`.
///
/// You can listen to its changes using `.addListener()`
class Atom<T> extends Quantum<T> {
  Atom(
    T initialValue, {
    this.persistentStorageInterface,
  })  : _value = initialValue,
        _initialized = persistentStorageInterface == null {
    _initPersistency();
  }

  T _value;

  /// [true] if the Atom has successfully retrieved data from persistent storage, or immediately if it doesn't have one
  bool _initialized;
  bool get initialized => _initialized;

  final AtomPersistentStorageInterface<T>? persistentStorageInterface;

  Future<void> _initPersistency() async {
    if (persistentStorageInterface == null) return;

    if (persistentStorageInterface!.initialValueFromStorage) {
      try {
        final v = await persistentStorageInterface!.get();

        _value = v;
        _initialized = true;
        notifyListeners();

        return;
      } catch (e) {
        persistentStorageInterface!.onGetError(e, _value);
        _initialized = true;
        notifyListeners();
        return;
      }
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
