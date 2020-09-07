import 'package:tareas/logic/delegates/loading.dart';
import 'package:tareas/network/auth/service.dart';


class StartupManager {

  final LoadingDelegate loadingDelegate = LoadingDelegate();

  void initializeAuth({ Function onSuccess, Function onError }) {
    Future initializationFuture = AuthService().initialize().then((value) {
      if (onSuccess != null)
        onSuccess();
    }).catchError((e) {
      if (onError != null)
        onError(e);
    });
    loadingDelegate.attachFuture(initializationFuture);
  }

  void tryAutoInitialize({ Function onSuccess, Function onError }) {
    AuthService().loadCachedAuthResult().then((value) {
      if (value != null) {
        loadingDelegate.isLoading = true;
        AuthService().initialize().then((_) {
          if (onSuccess != null)
            onSuccess();
        }).catchError((e) {
          if (onError != null)
            onError(e);
          loadingDelegate.isLoading = false;
        });
      }
    });
  }

}