import 'package:flutter/widgets.dart';

import '../interfaces/quantum_interface.dart';

typedef WidgetBuilder<V> = Widget Function(
  BuildContext context,
  V particleValue,
);

class QuantumBuilder<K> extends StatelessWidget {
  final Quantum<K> quantum;
  final WidgetBuilder<K> builder;
  const QuantumBuilder({
    super.key,
    required this.quantum,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: quantum,
      builder: (BuildContext context, Widget? child) {
        return builder(context, quantum.value);
      },
    );
  }
}
