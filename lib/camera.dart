import 'package:camera/camera.dart';
import 'package:sdui/sdui.dart';

void initCamera() async {
  sduiCameras = await availableCameras();
}
