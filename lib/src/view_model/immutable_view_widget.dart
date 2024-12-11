import 'package:flutter/material.dart';
import 'package:jelly_2vm/view_model.dart';

/// An immutable view widget that can be used to create const ViewWidgets
///
/// This widget has limitations:
/// - It can't have a context or vsync
/// - Delegates CAN be used, but probably less useful
///
/// If you need the context or vsync, use [ViewWidget] instead
abstract class ImmutableViewWidget<T extends ViewModel> extends StatefulWidget {
  const ImmutableViewWidget({
    Key? key,
  }) : super(key: key);

  T createViewModel();
  Widget builder(BuildContext context, T viewModel);

  void initState(T viewModel) {}

  void dispose(T viewModel) {}

  @override
  State<ImmutableViewWidget<T>> createState() => _ImmutableViewWidgetState<T>();
}

class _ImmutableViewWidgetState<T extends ViewModel>
    extends State<ImmutableViewWidget<T>> {
  late T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.createViewModel();
    widget.initState(viewModel);
  }

  @override
  void dispose() {
    widget.dispose(viewModel);
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, viewModel);
  }
}
