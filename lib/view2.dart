library jelly_2vm;

import 'package:flutter/material.dart';
import 'package:jelly_2vm/view-model.dart';

abstract class View2<T extends ViewModel> extends StatefulWidget {
  View2({
    Key? key,
  }) : super(key: key);

  final _BuildContextContainer _contextContainer = _BuildContextContainer();

  T createViewModel();
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
  State<View2<T>> createState() => _ViewState2<T>();
}

class _ViewState2<T extends ViewModel> extends State<View2<T>>
    with TickerProviderStateMixin {
  late T viewModel;
  @override
  void initState() {
    super.initState();
    widget._contextContainer.vsync = this;
    viewModel = widget.createViewModel();
    widget.initState(viewModel);
  }

  @override
  void dispose() {
    widget.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(View2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted && context != null) {
      widget._contextContainer.context = context;
      widget._contextContainer.vsync = this;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._contextContainer.context = context;
    widget._contextContainer.vsync = this;
    return widget.builder(context, viewModel);
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
