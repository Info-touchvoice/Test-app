import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

enum CameraMode { front, back }

class CameraViewModel extends GetxController {
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  Future<void>? _initializeControllerFuture;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;

  List<CameraDescription> _availableCameras = [];
  CameraMode? currentMode;

  final Completer<void> _controllerCompleter = Completer<void>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> _loadCameras() async {
    try {
      _availableCameras = await availableCameras();
    } catch (e) {
      debugPrint("Camera load error: $e");
    }
  }

  Future<void> initializeCamera(CameraMode cameraMode) async {
    if (cameraController != null &&
        cameraMode == currentMode &&
        _initializeControllerFuture != null) {
      return;
    }

    currentMode = cameraMode;

    await _loadCameras();

    final direction = (cameraMode == CameraMode.front)
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    // Pick matching camera
    final selectedCamera = _availableCameras.firstWhere(
      (cam) => cam.lensDirection == direction,
      orElse: () => _availableCameras.first,
    );

    // Initialize new controller
    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    update();
  }

  Future<void> switchCameraMode() async {
    _initializeControllerFuture = _controllerCompleter.future;
    await _cameraController?.dispose(); // Dispose previous controller

    // Determine lens direction based on mode
    final direction = (currentMode == CameraMode.front)
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    currentMode =
        (currentMode == CameraMode.front) ? CameraMode.back : CameraMode.front;

    // Pick matching camera
    final selectedCamera = _availableCameras.firstWhere(
      (cam) => cam.lensDirection == direction,
      orElse: () => _availableCameras.first,
    );

    // Initialize new controller
    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: true,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    update(); // Trigger UI update via GetX
  }

  @override
  void onClose() {
    _cameraController?.dispose();
    super.onClose();
  }

  CameraViewModel();
}
