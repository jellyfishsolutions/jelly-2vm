# I Quantum

### Cos'è un Quantum

Un Quantum è un oggetto che rappresenta un valore che può cambiare nel tempo e notifica i suoi listener quando viene modificato.

### Perché

A volte avere uno stato di tutta la pagina può portare a problemi di performance, per questo motivo si può utilizzare un Quantum per rappresentare lo stato di una determinata porzione della pagina. Usando poi il QuantumBuilder si può rendere la porzione reattiva.

### Come

Prendiamo come esempio un semplice contatore:

```dart
// counter_view.dart

class CounterView extends ViewWidget<CounterViewModel> {
  const CounterView({super.key});
  
  @override
  HomeViewModel createViewModel() {
    return HomeViewModel(delegate: this);
  }

  @override
  Widget build(BuildContext context, CounterViewModel viewModel) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            QuantumBuilder<int>(
              quantum: viewModel.counter,
              builder: (context, value) {
                return Text('$value');
              },
            ),
            ElevatedButton(
              onPressed: viewModel.increment,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```

```dart
// counter_view_model.dart

class CounterViewModel extends ViewModel {
  final Quantum<int> counter = Quantum<int>(0);

  void increment() {
    counter.value++;
  }
}
```

In questo modo possiamo limitare la reattività al solo testo da ri-renderizzare.

(Per un esempio più completo, si può vedere l'esempio in [HomeView](https://github.com/jelly-dart/jelly_2vm/blob/main/example/home/home_view.dart))

### Persistenza degli atomi

Il valore di un atom può essere persistito utilizzando `persistentStorageInterface`

```dart
final persistedCounter = Atom.persisted(
  0,
  persistentStorageInterface: PersistentStorageInterface(
    key: 'counter',
    encoder: (value) => value.toString(),
    decoder: (value) => value != null ? int.parse(value) : 0,
  ),
);
```
In questo modo il valore di `persistedCounter` sarà salvato e potrà essere recuperato anche dopo il riavvio dell'app.

### Molecole

Le molecole sono funzioni che prendono uno (o più) quantum come input e restituiscono un altro quantum come output.

```dart
final showWarning = MoleculeFrom1<int, bool>(
  quantum: persistedCounter,
  map: (value) => value > 10,
);
```

Possono essere utilizzate per processare i dati di un quantum resistuendo ad esempio una stringa da mostrare.