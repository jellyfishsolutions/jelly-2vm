import 'package:flutter/foundation.dart';

abstract class Quantum<T> extends ChangeNotifier {
  T get value;
}
