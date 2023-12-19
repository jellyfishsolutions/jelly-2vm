import 'package:flutter/material.dart';

typedef WidgetBuilder<S> = Widget Function(BuildContext context, S state);

/// ### ChangeBuilder: Build reactive UI
///
/// Pass the class of your ViewModel (or any [Listenable]), you'll be able to use a builder
/// method that provides the [Listenable] in order to access element inside it.
///
/// Example of a basic usage with a ViewModel
///
///```
///  @override
///  Widget builder(BuildContext context, CounterViewModel viewModel) {
///    [...]
///    ChangeBuilder<CounterViewModel>(
///      listen: counterViewModel,
///      builder: (context, state) => Text("${state.count}")),
///    [...]
///  )
///```
class ChangeBuilder<T extends ChangeNotifier> extends StatelessWidget {
  const ChangeBuilder({Key? key, required this.listen, required this.builder})
      : super(key: key);

  final T listen;
  final WidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: listen,
        builder: (BuildContext context, Widget? child) {
          return builder(context, listen);
        });
  }
}
