## Delegate nel Model-View-ViewModel di Appfactory

### Cos'è un delegate

Un delegate permette ad un viewModel di eseguire funzioni che utilizzano l'interfaccia, ad esempio, aprire un popup in seguito ad un errore.

### Perché

Ipotizziamo di avere una pagina di Login, nella View di questa pagina è presente un pulsante che chiama un metodo (asincrono) all'interno del relativo ViewModel, noi vogliamo che, una volta eseguita la chiamata, l'applicazione passi alla pagina successiva.

Per avere meno logica possibile all'interno della View utilizzeremo solo due metodi, uno per andare alla pagina successiva `goToNextPage` e uno per mostrare un popup di errore `showLoginErrorAlert`.

Sempre al fine di avare meno logica nella View vogliamo in qualche modo chiamare questi due metodi dal viewModel, ecco che entrano in gioco i delegate, ovvero **oggetti** a cui si possono **delegare azioni**, queste azioni sono definite in un'interfaccia che la View deve implementare, e di conseguenza i suoi metodi.

### Come

In questo caso ci riferiamo a delegate tra View e ViewModel, ma il concetto si può estendere anche ai Service.

Nella View creiamo l'interfaccia del Delegate
```dart
// login_view.dart

abstract class LoginViewDelegate {
  // Il viewModel potrebbe essere comodo per chiamare metodi in seguito
  onLoginError(Object e, LoginViewModel viewModel); 
  onLoginSuccess(LoginViewModel viewModel); 
}
```

Adattiamo il ViewModel
```dart
// login_view_model.dart

// import

class LoginViewModel extends ViewModel with ViewModelDelegator<LoginView>{ // 1 - ViewModelDelegator mixin
  LoginViewModel({required LoginViewDelegate delegate}){
    addDelegate(delegate); // 2 - addDelegate
  }
}
```

- Nello Step 1 aggiungiamo il mixin ViewModelDelegator al ViewModel, questo mixin non è altro che un'astrazione dell'aggiunta/rimozione dei delegate, espone anche un metodo per chiamare i delegate, che vedremo dopo.

- Nello Step 2 aggiungiamo il delegate, che viene passato nel costruttore, al ViewModel.

Passiamo il delegate al ViewModel in fase di creazione nella View, e implementiamo i metodi
```dart
class LoginView extends ViewWidget<LoginViewModel> 
    implements LoginViewDelegate{
  // code
  
  @override
  LoginViewModel createViewModel() {
    return LoginViewModel(delegate: this); // LoginView è esso stesso il delegate
  }

  @override
  onLoginError(Object e, LoginViewModel viewModel){
    showDialog(
      // code
    );
  }

  @override
  onLoginSuccess(Object e, LoginViewModel viewModel){
    
  }

  void goToNextPage(){
    if(!context.mounted) return; // Check that the context is still mounted
    context.pushNamed(...);
  }

  void showLoginErrorAlert{
    if(!context.mounted) return; // Check that the context is still mounted
    showDialog(
      ...
    );
  }


  // code
}
```

Possiamo adesso usare il delegate dal ViewModel in questo modo

```dart
// code

Future<void> makeLogin({required String email, required String password}){
  try{
    // Make api call

    // Handling success
    delegateAction((delegate) => delegate.onLoginSuccess(this))
  }catch (e){
    delegateAction((delegate) => delegate.onLoginError(e, this))
  }
}

// code
```

Così facendo nella View dovremo solo chiamare `makeLogin` senza aspettare il suo completamento.