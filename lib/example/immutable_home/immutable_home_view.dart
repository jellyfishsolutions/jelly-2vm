import 'package:flutter/material.dart';
import 'package:jelly_2vm/quantum.dart';
import 'package:jelly_2vm/src/view_model/immutable_view_widget.dart';

import 'immutable_home_view_model.dart';

class ImmutableHomeView extends ImmutableViewWidget<ImmutableHomeViewModel> {
  const ImmutableHomeView({super.key});

  @override
  ImmutableHomeViewModel createViewModel() {
    return ImmutableHomeViewModel();
  }

  @override
  Widget builder(BuildContext context, ImmutableHomeViewModel viewModel) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuantumBuilder(
              quantum: viewModel.counter,
              builder: (context, counter) => Text('$counter'),
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
