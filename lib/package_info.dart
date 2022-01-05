import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:sdui/sdui.dart';

class HttpPackageInfoInterceptor extends HttpInterceptor {
  PackageInfo? _packageInfo;

  @override
  void onRequest(RequestTemplate request) async {
    PackageInfo pi = await _loadPackageInfo();
    request.headers['X-Client-Version'] = '${pi.version}.${pi.buildNumber}';
    request.headers['X-OS'] = Platform.operatingSystem;
    request.headers['X-OS-Version'] = Platform.operatingSystemVersion;
  }

  @override
  void onResponse(ResponseTemplate response) {}

  Future<PackageInfo> _loadPackageInfo() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
    return _packageInfo!;
  }
}
