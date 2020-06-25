import 'package:scoped_model/scoped_model.dart';
import 'package:tareas/managers/extensions.dart';
import 'package:tareas/network/auth/service.dart';


class StartupManager extends Model {

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
        initializeAuth(
          onSuccess: onSuccess,
          onError: onError
        );
      }
    });
  }

}