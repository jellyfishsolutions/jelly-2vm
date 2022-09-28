library jelly_2vm;

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
