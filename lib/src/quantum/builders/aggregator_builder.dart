import 'package:flutter/material.dart';

import '../../../quantum.dart';

class AggregatorBuilder extends StatelessWidget {
  final QuantumAggregator<dynamic> moleculeAggregator;
  final Widget Function(BuildContext context) builder;

  const AggregatorBuilder({
    super.key,
    required this.moleculeAggregator,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: moleculeAggregator,
      builder: (BuildContext context, Widget? child) {
        return builder(context);
      },
    );
  }
}
