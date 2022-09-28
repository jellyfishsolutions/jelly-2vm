library jelly_2vm;

typedef WidgetBuilder<S> = Widget Function(BuildContext context, S state);

class ChangeBuilder<T extends ChangeNotifier> extends StatefulWidget {
  ChangeBuilder({Key? key, required this.watch, required this.builder})
      : super(key: key);

  final T watch;
  final WidgetBuilder<T> builder;
  
  @override
  _ChangeBuilderState createState() => _ChangeBuilderState<T>(watch, builder);
}

class _ChangeBuilderState<T extends ChangeNotifier>
    extends State<ChangeBuilder> {

  final WidgetBuilder<T> builder;
  final T watch;

  _ChangeBuilderState(this.watch, this.builder);

  @override
  void initState() {
    watch.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, watch);
  }
}

