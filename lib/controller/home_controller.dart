import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class HomeController extends GetxController {
  late List<CameraDescription> _cameras;
  late CameraController cameraController;

  int count = 0;

  List<Map<String, double>> pointPosition = [];

  bool loaded = false;

  @override
  Future<void> onReady() async {
    super.onReady();

    loaded = true;
    update();

    _cameras = await availableCameras();

    cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      loaded = true;
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
    print(
        "Size x-axis = ${cameraController.value.previewSize?.width} y-axis = ${cameraController.value.previewSize?.height}");

    cameraController.startImageStream((image) async {
      count++;
      if (count == 15) {
        count = 0;
        final WriteBuffer allBytes = WriteBuffer();
        for (final Plane plane in image.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        final bytes = allBytes.done().buffer.asUint8List();

        final Size imageSize =
            Size(image.width.toDouble(), image.height.toDouble());

        const InputImageRotation imageRotation =
            InputImageRotation.rotation0deg;

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

        final inputImage =
            InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

        final options = PoseDetectorOptions(
            mode: PoseDetectionMode.stream, model: PoseDetectionModel.base);
        final poseDetector = PoseDetector(options: options);

        final List<Pose> poses = await poseDetector.processImage(inputImage);

        pointPosition = poses.first.landmarks.values
            .map((e) => {"top": e.x / 1280.0, "left": e.y / 720.0})
            .toList();
        print("points $pointPosition");

        update();
      }
    });
  }
}
