abstract class AtomPersistentStorageInterface<T> {
  Future<void> save(T value);

  Future<T> get();

  void onSaveError(Object? e);
  void onSaveSuccess(Object? e);

  T onGetError(Object? e, T lastValue);

  bool get initialValueFromStorage;
}
