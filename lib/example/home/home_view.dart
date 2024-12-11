import 'package:flutter/material.dart';
import 'package:jelly_2vm/quantum.dart';
import 'package:jelly_2vm/view_model.dart';

import './home_view_model.dart';

abstract class HomeViewDelegate {
  void onCounterChanged(int counter);
}

class HomeView extends ViewWidget<HomeViewModel> implements HomeViewDelegate {
  HomeView({Key? key}) : super(key: key);

  @override
  HomeViewModel createViewModel() {
    return HomeViewModel(delegate: this);
  }

  @override
  void onCounterChanged(int counter) {
    // TODO: implement onCounterChanged
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuantumBuilder(
              quantum: viewModel.counter,
              builder: (context, counter) => Text('$counter'),
            ),
            QuantumBuilder(
              quantum: viewModel.showWarning,
              builder: (context, showWarning) =>
                  const Text('Warning: You are over 10'),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.counter.value++;
              },
              child: const Text('Increment'),
            )
          ],
        ),
      ),
    );
  }
}
