library jelly_2vm;

import 'package:flutter/material.dart';
import 'package:jelly_2vm/view-model.dart';

/// ### View: The UI
///
/// Define the UI of the widget with this, just create a class that extends View,
/// pass the ViewModel and @override the builder method, you'll then be able to access the ViewModel
///
/// Example of basic implementation:
///
/// ```
/// class CounterView extends View<CounterViewModel> {
///   // Instanciate the Model with 0 as initial value and pass it to View
///   Counter({Key? key}) : super(key: key, viewModel: CounterViewModel(0));
///
///   @override
///   Widget builder(BuildContext context, CounterViewModel counterViewModel) {
///     return Scaffold(
///       body: SafeArea(
///           child: Center(
///         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
///           MaterialButton(
///             onPressed: () => counterViewModel.increment(1), // Call method of CounterViewModel
///             child: const Text("Increment"),
///           ),
///           ChangeBuilder<CounterViewModel>(
///             listen: counterViewModel, //Listen for notifyListener() of counterViewModel
///             builder: (context, state) => Text("${state.count}")),
///           MaterialButton(
///             onPressed: () => counterViewModel.decrement(1), // Call method of CounterViewModel
///             child: const Text("Decrement"),
///           ),
///         ]),
///       )),
///     );
///   }
/// }
/// ```
abstract class View<T extends ViewModel> extends StatefulWidget {
  View({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final T viewModel;
  final _BuildContextContainer _contextContainer = _BuildContextContainer();

  Widget builder(BuildContext context, T viewModel);

  void initState(T viewModel) {}

  void dispose() {}

  /// Obtains (if available) the current context
  BuildContext get context {
    if (_contextContainer.context == null) {
      throw 'Trying to access the context when is not yet initialized';
    }
    return _contextContainer.context!;
  }

  TickerProviderStateMixin get vsync {
    return _contextContainer.vsync!;
  }

  @override
  State<View<T>> createState() => _ViewState<T>();
}

class _ViewState<T extends ViewModel> extends State<View<T>>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget._contextContainer.vsync = this;
    widget.initState(widget.viewModel);
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._contextContainer.context = context;
    return widget.builder(context, widget.viewModel);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: unnecessary_null_comparison
    if (mounted && context != null) {
      widget._contextContainer.context = context;
    }
  }
}

class _BuildContextContainer {
  BuildContext? context;
  TickerProviderStateMixin? vsync;
}
