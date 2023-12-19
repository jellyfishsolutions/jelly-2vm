import 'package:flutter/widgets.dart';

import '../interfaces/quantum_interface.dart';

/// A [QuantumAggregator] simply listens to changes to multiple [Quantum]s, and call `notifyListeners()` when one of the [Quantum]s changes.
class QuantumAggregator<A> extends ChangeNotifier {
  final List<Quantum<A>> _quantumList;

  QuantumAggregator({
    required List<Quantum<A>> quantumList,
  }) : _quantumList = quantumList {
    for (final quantum in _quantumList) {
      quantum.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final quantum in _quantumList) {
      quantum.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
