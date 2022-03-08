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
      'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJ0ZW5hbnRfaWQiOjEsInN1YiI6IjE2Iiwic3ViX3R5cGUiOiJVU0VSIiwic2NvcGUiOlsiY2FydC1tYW5hZ2UiLCJjYXJ0LXJlYWQiLCJjYXRhbG9nLW1hbmFnZSIsImNhdGFsb2ctcmVhZCIsImNvbnRhY3QtbWFuYWdlIiwiY29udGFjdC1yZWFkIiwibWFpbC1zZW5kIiwib3JkZXItbWFuYWdlIiwib3JkZXItcmVhZCIsInBheW1lbnQtbWFuYWdlIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1yZWFkIiwicGF5bWVudC1yZWFkIiwicGF5bWVudC1yZWFkIiwicXItbWFuYWdlIiwicXItcmVhZCIsInNoaXBwaW5nLW1hbmFnZSIsInNoaXBwaW5nLXJlYWQiLCJzbXMtc2VuZCIsInNtcy12ZXJpZnkiLCJ0ZW5hbnQtcmVhZCIsInVzZXItbWFuYWdlIiwidXNlci1yZWFkIl0sImlzcyI6Ind1dHNpLmNvbSIsIm5hbWUiOiJIZXJ2ZSBUY2hlcGFubm91IiwiYWRtaW4iOmZhbHNlLCJwaG9uZV9udW1iZXIiOiIrMTUxNDc1ODAxOTEiLCJleHAiOjE2NDYyMjY0OTksImlhdCI6MTY0NjE0MTg5OSwianRpIjoiMSJ9.UFbRohUThHts3ZKZBfZbLJwA5KplKNgdewrS9hrUaseSbs1_osLoL4jykcgYT8T0i-8nEmA44l6G0qVo6FsXWWJExv6LSFgYfSt0GbkI4Fo7skcUpfVG5Df9xowmuKxZmsMaxUeXhQU2cI9-xBI';

  @override
  void onRequest(RequestTemplate request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  @override
  void onResponse(ResponseTemplate response) async {}
}
