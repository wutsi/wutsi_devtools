import 'package:sdui/sdui.dart';
import 'package:uuid/uuid.dart';

void initHttp() {
  Http.getInstance().interceptors = [
    HttpJsonInterceptor(),
    HttpAuthorizationInterceptor(),
    HttpTracingInterceptor('wutsi-devtools', const Uuid().toString(), 1),
  ];
}

/// Interceptor that add tracing information into the request headers.
/// The tracing information added are:
/// - `X-Device-ID`: ID of the device
/// - `X-Trace-ID`: ID that represent the interfaction trace
/// - `X-Client-ID`: Identification of the client application
class HttpTracingInterceptor extends HttpInterceptor {
  final String clientId;
  final String deviceId;
  final int tenantId;

  HttpTracingInterceptor(this.clientId, this.deviceId, this.tenantId);

  @override
  void onRequest(RequestTemplate request) async {
    request.headers['X-Device-ID'] = clientId;
    request.headers['X-Trace-ID'] = const Uuid().v1();
    request.headers['X-Device-ID'] = deviceId;
    request.headers['X-Tenant-ID'] = tenantId.toString();
  }

  @override
  void onResponse(ResponseTemplate response) {}
}

/// HTTP interceptor that adds Authorization header
class HttpAuthorizationInterceptor extends HttpInterceptor {
  final String accessToken =
      'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIxNiIsInN1Yl90eXBlIjoiVVNFUiIsInNjb3BlIjpbInBheW1lbnQtbWFuYWdlIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1yZWFkIiwicGF5bWVudC1yZWFkIiwicGF5bWVudC1yZWFkIiwic21zLXNlbmQiLCJzbXMtdmVyaWZ5IiwidGVuYW50LXJlYWQiLCJ1c2VyLW1hbmFnZSIsInVzZXItcmVhZCJdLCJpc3MiOiJ3dXRzaS5jb20iLCJuYW1lIjoiSGVydmUgVGNoZXBhbm5vdSIsImFkbWluIjpmYWxzZSwicGhvbmVfbnVtYmVyIjoiKzE1MTQ3NTgwMTkxIiwiZXhwIjoxNjM3MjU3NTg2LCJpYXQiOjE2MzcxNzI5ODYsImp0aSI6IjEifQ.YXHWrUaBRA5OAu7CNtB-HKIIkVTAd764Zl85bOzGBASchkDkMWsRXmmSz2k4xgS0kHaxUTgnDbqFkR6ylQdSL5NSvpojy7mZjjFiAieE0xuD1frHfv3u9EmwiC-tXkvZossz6TB0aTU69OG5S6GebJJ3F7Pkiic4l0uHC3BmNgVqkC0ukfPMQ_bnoxxAXfpqPk4emjkCbcf8Iurj5C1r5JGrRE8K_vosVuNgxRE-4sLE4aqDI5bLIXJWXuz1VdUoMcFxkBYVkyx6Jcfy51uaLDf1hrOuKOdMSvze5O2ZRQ0YgUjysB';

  @override
  void onRequest(RequestTemplate request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  @override
  void onResponse(ResponseTemplate response) async {}
}
