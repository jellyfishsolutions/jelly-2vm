# jelly-2vm

## Why

Simple library that helps you implementing `view<->viewModel<->[service]` paradigm in Flutter, main advantages of this paradigm are:

- UI and business logic completely separated
- Being able to test functionality without UI

## Get started

Let's build a basic counter!

### Step 0

Create starter project and clean `main.dart`

```dart
// main.dart
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2VM Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterView(),
    );
  }
}
```

### Step 1

Create a Counter `Model` that extends `ViewModel`

Here we will put all the business logic for the Counter

```dart
// pages/counter/counter-view-model.dart
class CounterViewModel extends ViewModel {
  // Instanciate the model with an initial value when you call it
  CounterViewModel(this.count);
  int count;

  void increment(int amount) {
    count += amount;
    notifyListeners(); //We'll use this later to make the view reactive
  }

  void decrement(int amount) {
    count -= amount;
    notifyListeners(); //We'll use this later to make the view reactive
  }
}
```

### Step 2

Create a Counter `View` that extends `ViewWidget`

Here we will put the UI for the Counter

```dart
// pages/counter/counter-view.dart
class CounterView extends ViewWidget<CounterViewModel> {
  Counter({Key? key}) : super(key: key);

  // Instantiate the Model with 0 as initial value and pass it to View
  @override
  CounterViewModel createViewModel() {
    return CounterViewModel(0);
  }

  @override
  Widget builder(BuildContext context, CounterViewModel counterViewModel) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          MaterialButton(
            onPressed: () => counterViewModel.increment(1), // Call method of CounterViewModel
            child: const Text("Increment"),
          ),
          ChangeBuilder<CounterViewModel>( // You need to pass the class of your [ViewModel]
            // Reactive part of the view, you can move ChangeBuilder to make even the whole view rerender when notifyListener()
            listen: counterViewModel, //Listen for notifyListener() of counterViewModel
            builder: (context, state) => Text("${state.count}")),
          MaterialButton(
            onPressed: () => counterViewModel.decrement(1), // Call method of CounterViewModel
            child: const Text("Decrement"),
          ),
        ]),
      )),
    );
  }
}
```

### Step 3

Enjoy your reactive view!

You can now add API service calls in your ViewModel

If you want to share data between views make yourself a `StateManager`: just create a Singleton that extends ChangeNotifier, then save shared data in there and trigger `notifyListener()` when it changes. Then pass this to `ChangeBuilder` in different views, et voilà, reactive view from shared data.

Example:

```dart
// providers/counter-provider.dart
class CounterStateManager extends ChangeNotifier {
  // Make CounterStateManager a singleton
  static final CounterStateManager _singleton = CounterStateManager._internal();
  factory CounterStateManager() {
    return _singleton;
  }
  CounterStateManager._internal();

  // Define state and logic
  int _count = 0;

  int get count => _count;
  set count(int newCount) {
    _count = newCount;
    notifyListeners();
  }
}
```

Usage with ChangeBuilder

```dart
// any-view.dart
ChangeBuilder<CounterStateManager>(
  watch: CounterStateManager(), //Listen for notifyListener() of stateManager
  builder: (context, state) => Text("${state.count}"),
)
```

### Delegator 🐊

Inspired by Swift for iOS, it will help you to dispatch functions that will run on the View from your ViewModel.

**View**

```dart
// Create View specific delegate
abstract class Delegate1 {
  onApiError(Object? e);
}

// Create union of multiple delegates, since dart doesn't allow implicit union when using dynamics
abstract class CounterViewDelegates implements Delegate1, Delegate2 {}

// Implement the delegate(s)
class CounterView extends ViewModel<CounterViewModel> implements CounterViewDelegates{
  ...
  @override
  TeamBuilderViewModel createViewModel() {
    // Pass delegate (the View itself) to ViewModel
    return TeamBuilderViewModel(delegate: this);
  }

  // Implement all the methods from the delegates
  @override
  onApiError(Object? e){
    // Handle Api Error
  }
  ...
}
```

**ViewModel**

```dart
// Use the ViewModelDelegator giving the (union of) delegates from the View
class CounterViewModel extends ViewModel with ViewModelDelegator<CounterViewDelegates>{
  // Add delegate when instantiated
  CounterViewModel({required CounterViewDelegates delegate}){
    addDelegate(delegate);
  }
  ...
  try{
    ...
  } catch(e){
    // Call the delegate(s) with the specific action
    delegateAction((delegate) => delegate.onApiError(e));
  }
  ...
}
```
