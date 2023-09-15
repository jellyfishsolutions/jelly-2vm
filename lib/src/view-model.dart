import 'package:flutter/material.dart';

/// ### ViewModel: Define logic of the view here.
///
/// Use this class to define the logic of your view, since it extends ChangeNotifier
/// you will be able to use it with the ChangeBuilder.
///
/// Example of a basic counter implentation
///
/// ```
///class CounterViewModel extends ViewModel {
///  CounterViewModel(this.count);
///  int count;
///
///  void increment(int amount) {
///    count += amount;
///    notifyListeners();
///  }
///
///  void decrement(int amount) {
///    count -= amount;
///    notifyListeners();
///  }
///}
///```
class ViewModel extends ChangeNotifier {}

class ViewModelDelegator<T> {
  final List<T> _delegates = [];

  void addDelegate(T delegate) {
    if (_delegates.contains(delegate)) {
      return;
    }
    _delegates.add(delegate);
  }

  void notifyDelegates(Function(T delegate) exec) {
    for (final d in _delegates) {
      try {
        exec(d);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void removeDelegate(T delegate) {
    _delegates.remove(delegate);
  }

  void removeAllDelegates() {
    _delegates.clear();
  }
}
