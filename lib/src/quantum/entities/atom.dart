import 'dart:async';

import 'package:jelly_2vm/src/quantum/interfaces/persistent_storage_interface.dart';
import 'package:jelly_2vm/src/quantum/interfaces/quantum_interface.dart';

/// An [Atom] is the smallest reactive entity, you can set its `.value` and it will call `notifyListeners()`.
///
/// You can listen to its changes using `.addListener()`
class Atom<T> extends Quantum<T> {
  Atom(T initialValue)
      : _value = initialValue,
        _initialized = true,
        _persistentStorageInterface = null,
        _initializedCompleter = null;

  Atom.persisted(
    T initialValue, {
    required AtomPersistentStorageInterface<T> persistentStorageInterface,
  })  : _persistentStorageInterface = persistentStorageInterface,
        _value = initialValue,
        _initialized = false,
        _initializedCompleter = Completer() {
    _initPersistency();
  }

  T _value;

  /// [true] if the Atom has successfully retrieved data from persistent storage, or immediately if it doesn't have one
  bool _initialized;
  bool get initialized => _initialized;

  // Persistency

  final AtomPersistentStorageInterface<T>? _persistentStorageInterface;

  final Completer<void>? _initializedCompleter;

  /// Only for [Atom.persisted]
  late final Future<void> initializedAsFuture = _initializedCompleter!.future;

  Future<void> _initPersistency() async {
    if (_persistentStorageInterface == null) return;

    if (_persistentStorageInterface!.initialValueFromStorage) {
      try {
        final v = await _persistentStorageInterface!.get();

        _value = v;
        _initialized = true;
        _initializedCompleter!.complete();
        notifyListeners();

        return;
      } catch (e) {
        _persistentStorageInterface!.onGetError(e, _value);
        _initialized = true;
        _initializedCompleter!.complete();
        notifyListeners();
        return;
      }
    }
  }

  // Getters/Setters

  @override
  T get value => _value;

  set value(T v) {
    _value = v;

    _persistentStorageInterface
        ?.save(v)
        .then(_persistentStorageInterface!.onSaveSuccess)
        .catchError(_persistentStorageInterface!.onSaveError);

    notifyListeners();
  }

  bool get isNull => _value == null;
}
