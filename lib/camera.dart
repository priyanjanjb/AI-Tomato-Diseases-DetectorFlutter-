import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart'; // Assuming this package is used for saving or displaying the image

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setupCameraController();
  }

  Future<void> setupCameraController() async {
    cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      cameraController = CameraController(cameras.first, ResolutionPreset.high);

      try {
        await cameraController?.initialize();
        if (!mounted) return;
        setState(() {});
      } catch (e) {
        print('Error initializing camera: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildUI(),
    );
  }

  Widget buildUI() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            // Centering the camera preview
            child: SizedBox(
              height: 500,
              width: 300, // Adjust width to fit within your layout
              child: CameraPreview(cameraController!),
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                XFile picture = await cameraController!.takePicture();
                Gal.putImage(picture
                    .path); // Save or handle the image using the 'Gal' package
              } catch (e) {
                print('Error capturing image: $e');
              }
            },
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
