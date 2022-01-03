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
  void onRequest(RequestTemplate request) async {
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
      'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJ0ZW5hbnRfaWQiOjEsInN1YiI6IjE2Iiwic3ViX3R5cGUiOiJVU0VSIiwic2NvcGUiOlsiY29udGFjdC1tYW5hZ2UiLCJjb250YWN0LXJlYWQiLCJwYXltZW50LW1hbmFnZSIsInBheW1lbnQtbWFuYWdlIiwicGF5bWVudC1tZXRob2QtbWFuYWdlIiwicGF5bWVudC1tZXRob2QtcmVhZCIsInBheW1lbnQtcmVhZCIsInBheW1lbnQtcmVhZCIsInFyLW1hbmFnZSIsInFyLXJlYWQiLCJzbXMtc2VuZCIsInNtcy12ZXJpZnkiLCJ0ZW5hbnQtcmVhZCIsInVzZXItbWFuYWdlIiwidXNlci1yZWFkIl0sImlzcyI6Ind1dHNpLmNvbSIsIm5hbWUiOiJIZXJ2ZSBUY2hlcGFubm91IiwiYWRtaW4iOmZhbHNlLCJwaG9uZV9udW1iZXIiOiIrMTUxNDc1ODAxOTEiLCJleHAiOjE2NDA3NTYyNjMsImlhdCI6MTY0MDY3MTY2MywianRpIjoiMSJ9.Hz50-X_oy_O0MXqAKIC2ep7xu4NLRDriB66FdtsVt-agKYdVVet36zlw_MhwjiG5StyGTMvQFw620-MBen5oc4W8Y_FL9_zxz7uIDUBsdY4rwPRE05o7wS7b45hDx24hl0LD62Y9V8yI3KGUdcOTe72_zXxRdzqZlioBeXvzqtjhANKt3TZk34';

  @override
  void onRequest(RequestTemplate request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  @override
  void onResponse(ResponseTemplate response) async {}
}
