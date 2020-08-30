import 'dart:io';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "PROXY localhost:8888";
      }
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}