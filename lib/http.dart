import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:sdui/sdui.dart';
import 'package:uuid/uuid.dart';
import 'package_info.dart';
import 'package:logger/logger.dart';

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
  static final Logger _logger = LoggerFactory.create("HttpAuthorizationInterceptor");
  String accessToken = '';

  @override
  void onRequest(RequestTemplate request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  @override
  void onResponse(ResponseTemplate response) async {
    String? value = response.headers['x-access-token'];
    if (value != null) {
      _logger.i('AccessToken: $value');
      accessToken = value;
    }
  }
}
