import 'package:flutter/foundation.dart';

/// ### ViewModelDelegator
/// Example:
///
/// Define a (union of) delegate
///
/// ```
/// // file: counter-view.dart
/// abstract class Delegate1 {
///   onApiError(Object? e);
/// }
///
/// abstract class CounterViewDelegates implements Delegate1, Delegate2 {}
///
/// class CounterView extends ViewModel<CounterViewModel> implements CounterViewDelegates{
///   ...
///   @override
///   TeamBuilderViewModel createViewModel() {
///     // Pass delegate (the View itself) to ViewModel
///     return TeamBuilderViewModel(delegate: this);
///   }
///   @override
///   onApiError(Object? e){
///     // Handle Api Error
///   }
///   ...
/// }
/// ```
///
/// Use it in view model
/// ```
/// // file: counter-view-model.dart
/// class CounterViewModel extends ViewModel with ViewModelDelegator<CounterViewDelegates>{
///   ...
///   // Add delegate when instantiated
///   CounterViewModel({required CounterViewDelegates delegate}) {
///     addDelegate(delegate);
///   }
///
///   try{
///     ...
///   } catch(e){
///     delegateAction((delegate) => delegate.onApiError(e));
///   }
///   ...
/// }
/// ```
mixin ViewModelDelegator<T> {
  final List<T> _delegates = [];

  void addDelegate(T delegate) {
    if (_delegates.contains(delegate)) {
      return;
    }
    _delegates.add(delegate);
  }

  void delegateAction(Function(T delegate) exec) {
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
