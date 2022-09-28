library jelly_2vm;

abstract class View<T extends ViewModel> extends StatefulWidget {
  View({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  T viewModel;
  Widget builder(BuildContext context, T viewModel);

  @override
  State<View<T>> createState() => _ViewState<T>();
}

class _ViewState<T extends ViewModel> extends State<View<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.viewModel);
  }
}

