import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/controller/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<HomeController>(
            init: homeController,
            builder: (controller) {
              if (controller.cameraController.value.isInitialized) {
                return CameraPreview(controller.cameraController);
              }


              return const Center(
                child: CircularProgressIndicator(),
              );
            }
    ));
  }
}
