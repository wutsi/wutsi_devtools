import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:sdui/sdui.dart';
import 'package:uuid/uuid.dart';

import 'package_info.dart';

void initHttp() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  Http.getInstance().interceptors = [
    HttpJsonInterceptor(),
    HttpAuthorizationInterceptor(),
    HttpPackageInfoInterceptor(),
    HttpTracingInterceptor('wutsi-devtools', const Uuid().v1(), 1, packageInfo),
  ];

  DynamicRouteState.statusCodeRoutes[401] = '/401';
}

/// Interceptor that add tracing information into the request headers.
/// The tracing information added are:
/// - `X-Device-ID`: ID of the device
/// - `X-Trace-ID`: ID that represent the interfaction trace
/// - `X-Client-ID`: Identification of the client application
class HttpTracingInterceptor extends HttpInterceptor {
  // static final Logger _logger = LoggerFactory.create("HttpTracingInterceptor");

  final String clientId;
  final String deviceId;
  final int tenantId;
  PackageInfo packageInfo;

  HttpTracingInterceptor(
      this.clientId, this.deviceId, this.tenantId, this.packageInfo);

  @override
  void onRequest(RequestTemplate request) {
    request.headers['X-Client-ID'] = clientId;
    request.headers['X-Trace-ID'] = const Uuid().v1();
    request.headers['X-Device-ID'] = deviceId;
    request.headers['X-Tenant-ID'] = tenantId.toString();

    request.headers['X-Client-Version'] =
        '${packageInfo.version}.${packageInfo.buildNumber}';
    request.headers['X-OS'] = Platform.operatingSystem;
    request.headers['X-OS-Version'] = Platform.operatingSystemVersion;
  }

  @override
  void onResponse(ResponseTemplate response) {}
}

/// HTTP interceptor that adds Authorization header
class HttpAuthorizationInterceptor extends HttpInterceptor {
  final String accessToken =
      'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJ0ZW5hbnRfaWQiOjEsInN1YiI6IjM5Iiwic3ViX3R5cGUiOiJVU0VSIiwic2NvcGUiOlsiY2FydC1tYW5hZ2UiLCJjYXJ0LXJlYWQiLCJjYXRhbG9nLW1hbmFnZSIsImNhdGFsb2ctcmVhZCIsImNoYXQtbWFuYWdlIiwiY2hhdC1yZWFkIiwiY29udGFjdC1tYW5hZ2UiLCJjb250YWN0LXJlYWQiLCJvcmRlci1tYW5hZ2UiLCJvcmRlci1yZWFkIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLXJlYWQiLCJwYXltZW50LXJlYWQiLCJwYXltZW50LXJlYWQiLCJzaGlwcGluZy1tYW5hZ2UiLCJzaGlwcGluZy1yZWFkIiwidGVuYW50LXJlYWQiLCJ1c2VyLW1hbmFnZSIsInVzZXItcmVhZCJdLCJpc3MiOiJ3dXRzaS5jb20iLCJuYW1lIjoiTWFpc29uIEgiLCJhZG1pbiI6ZmFsc2UsInBob25lX251bWJlciI6IisyMzc2OTAwMDAwMDEiLCJleHAiOjE2NjQ3NDQ4ODEsImlhdCI6MTY2NDY2MDI4MSwianRpIjoiMSJ9.VVavgc6cV88KIhk6mZJlTVEPgA7rYp82892H5vbNlKu5BjVkUoOMrKFaVlvhMpR9ikbuwGlu5gGMmdKH36IzUaS7PAGa0UdTAZ3K0YWtNlnuEdMWp_MlTkZjrEWdYh-6zFxRG32vEviMp_Wn9ZIRnnoHQsmIX3KoK8SGceO7L-w8XMtvZvPLbA5AbWkGjfK8BH1NfgX';

  @override
  void onRequest(RequestTemplate request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  @override
  void onResponse(ResponseTemplate response) async {}
}
