import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_detection/controller/home_controller.dart';

import '../controller/point_on_camera.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<HomeController>(
            init: homeController,
            builder: (controller) {
              if (controller.loaded) {
                return Stack(
                  children: [
                    CameraPreview(controller.cameraController),
                    CustomPaint(
                      size: const Size(720, 1280),
                        painter: PointOnCamera(
                            pointPosition: controller.pointPosition))
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
