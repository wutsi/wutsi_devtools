import 'dart:io';

import 'package:logger/logger.dart';
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
  static final Logger _logger = LoggerFactory.create("HttpTracingInterceptor");

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
    try {
      request.headers['X-OS'] = Platform.operatingSystem;
      request.headers['X-OS-Version'] = Platform.operatingSystemVersion;
    } catch (ex) {
      _logger.e("Unable to resolve platform information", ex);
    }
  }

  @override
  void onResponse(ResponseTemplate response) {}
}

/// HTTP interceptor that adds Authorization header
class HttpAuthorizationInterceptor extends HttpInterceptor {
  final String accessToken =
      'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJ0ZW5hbnRfaWQiOjEsInN1YiI6IjE2Iiwic3ViX3R5cGUiOiJVU0VSIiwic2NvcGUiOlsiY2FydC1tYW5hZ2UiLCJjYXJ0LXJlYWQiLCJjYXRhbG9nLW1hbmFnZSIsImNhdGFsb2ctcmVhZCIsImNvbnRhY3QtbWFuYWdlIiwiY29udGFjdC1yZWFkIiwibWFpbC1zZW5kIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLXJlYWQiLCJwYXltZW50LXJlYWQiLCJwYXltZW50LXJlYWQiLCJxci1tYW5hZ2UiLCJxci1yZWFkIiwic21zLXNlbmQiLCJzbXMtdmVyaWZ5IiwidGVuYW50LXJlYWQiLCJ1c2VyLW1hbmFnZSIsInVzZXItcmVhZCJdLCJpc3MiOiJ3dXRzaS5jb20iLCJuYW1lIjoiSGVydmUgVGNoZXBhbm5vdSIsImFkbWluIjpmYWxzZSwicGhvbmVfbnVtYmVyIjoiKzE1MTQ3NTgwMTkxIiwiZXhwIjoxNjQ1Mjg0OTEyLCJpYXQiOjE2NDUyMDAzMTIsImp0aSI6IjEifQ.ksnO0I8fZ7lnEhUusz0X1YPr5JAY9PDEpnRzQ_RiwVfN9H5slVmXIcfIz0CnNMbPcV5Qk_VsIqu7VK7a2roXFcltEpqC6JA92nZyAhkofU7fbLMe1X-Vo3F-af8EAAizKvtsoCO0ZoxHUYIKnGp7S62mGAZYK0n4_5evdXTcgJRHk9QdvXsfktP2bUSJZiUYuFvPTSmih6R62jB1l5Nnp92KBPWlGRVTJ28Wf';

  @override
  void onRequest(RequestTemplate request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  @override
  void onResponse(ResponseTemplate response) async {}
}
