import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class HomeController extends GetxController {
  late List<CameraDescription> _cameras;
  late CameraController cameraController;

  @override
  Future<void> onReady() async {
    super.onReady();
    _cameras = await availableCameras();

    cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      update();
      imageStreaming();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  imageStreaming() {
    cameraController.startImageStream((image) async {

      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

      const InputImageRotation imageRotation = InputImageRotation.rotation0deg;

      final InputImageFormat inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw) ??
              InputImageFormat.nv21;

      final planeData = image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

      final options = PoseDetectorOptions(mode: PoseDetectionMode.single);
      final poseDetector = PoseDetector(options: options);

      final List<Pose> poses = await poseDetector.processImage(inputImage);

      for (Pose pose in poses) {

        pose.landmarks.forEach((_, landmark) {
          // final type = landmark.type;
          final x = landmark.x;
          final y = landmark.y;

          print(" x-axis = $x y-axis = $y");
        });
      }
      // to access specific landmarks
      // final landmark = pose.landmarks[PoseLandmarkType.nose];
    });
  }
}
