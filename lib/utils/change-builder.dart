library jelly_2vm;

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
class ChangeBuilder<T extends ChangeNotifier> extends StatefulWidget {
  const ChangeBuilder({Key? key, required this.listen, required this.builder})
      : super(key: key);

  final T listen;
  final WidgetBuilder<T> builder;

  @override
  _ChangeBuilderState createState() => _ChangeBuilderState<T>(listen, builder);
}

class _ChangeBuilderState<T extends ChangeNotifier>
    extends State<ChangeBuilder> {
  final WidgetBuilder<T> builder;
  final T listen;

  _ChangeBuilderState(this.listen, this.builder);

  _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    listen.addListener(_refresh);
    super.initState();
  }

  @override
  void dispose() {
    listen.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, listen);
  }
}
