import 'package:sdui/sdui.dart';
import 'package:uuid/uuid.dart';

void initHttp() {
  Http.getInstance().interceptors = [
    HttpJsonInterceptor(),
    HttpAuthorizationInterceptor(),
    HttpTracingInterceptor('wutsi-devtools', const Uuid().v1(), 1),
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
    request.headers['X-Client-ID'] = clientId;
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
      'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIxNiIsInN1Yl90eXBlIjoiVVNFUiIsInNjb3BlIjpbImNvbnRhY3QtbWFuYWdlIiwiY29udGFjdC1yZWFkIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLXJlYWQiLCJwYXltZW50LXJlYWQiLCJwYXltZW50LXJlYWQiLCJzbXMtc2VuZCIsInNtcy12ZXJpZnkiLCJ0ZW5hbnQtcmVhZCIsInVzZXItbWFuYWdlIiwidXNlci1yZWFkIl0sImlzcyI6Ind1dHNpLmNvbSIsIm5hbWUiOiJIZXJ2ZSBUY2hlcGFubm91IiwiYWRtaW4iOmZhbHNlLCJwaG9uZV9udW1iZXIiOiIrMTUxNDc1ODAxOTEiLCJleHAiOjE2MzgyODM2NTQsImlhdCI6MTYzODE5OTA1NCwianRpIjoiMSJ9.YZ62GDn_XeHRpQyqqVlAPT4lRYwIyM2qSpRjzTmgrz8xvPoXimizZQfTBuVI7KqnsAMg_ax-nggE-DzzwTShiQYvXGrzYeZV811o21e2G0_p5_rBAoQXXXivvA24ZaiU7YYL88SyJCHG6Veo4PpPkx4P3oqG03k1c31N_WOTbKA-2OrIFBSIHvPAr8030wN5kt26jiobrNAJW5ltZ7mPJ1d7aXfbmoqtZCELfrfZ0faugSG3l60azyDamxyexlTmwYgePUQUtuZkQXCsg-BRbdEkCGsMPcAsZAwbUuz_7Ja2yV8iAaW6TXlB-o_LqjoBUmem74GOUttmqONa5afgWg';

  @override
  void onRequest(RequestTemplate request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  @override
  void onResponse(ResponseTemplate response) async {}
}
