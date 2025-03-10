// ignore_for_file: avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart'; // Assuming this package is used for saving or displaying the image
import 'package:image_picker/image_picker.dart';
import 'package:tmtdiseases/results.dart'; // Import Results page

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

  // Function to select an image from the gallery
  Future<void> openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => Results(imagePath: image.path),
        ),
      ).then((_) {
        // Stop the camera after navigating
        cameraController?.dispose();
      });
    } else {
      print('No image selected.');
    }
  }

  // Function to capture an image and navigate to the results page
  Future<void> captureImage() async {
    try {
      XFile picture = await cameraController!.takePicture();

      // Navigate to the Results page with the captured image
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => Results(imagePath: picture.path),
        ),
      ).then((_) {
        // Stop the camera after navigating
        cameraController?.dispose();
      });

      // Optionally save the image using 'Gal' package
      Gal.putImage(picture.path);
    } catch (e) {
      print('Error capturing image: $e');
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black, // Setting background color to black
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: double.infinity, // Adjust width if necessary
                  height: MediaQuery.of(context).size.height *
                      0.6, // Example height
                  child: AspectRatio(
                    aspectRatio: 3 / 4.77, // Maintains the camera aspect ratio
                    child: CameraPreview(cameraController!),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black, // Setting background color to black
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space between icons
          children: [
            // Gallery Icon Button (Left Side)
            IconButton(
              onPressed: openGallery, // Opens the gallery
              icon: const Icon(
                Icons.collections, // Gallery icon
                color: Colors.white,
                size: 48,
              ),
            ),

            // Camera Capture Icon Button (Center)
            IconButton(
              onPressed:
                  captureImage, // Captures the image and navigates to Results
              icon: const Icon(
                Icons.radio_button_on,
                color: Colors.white,
                size: 48,
              ),
            ),

            // Square Icon Button (Right Side)
            IconButton(
              onPressed: () {
                // Add functionality for square action
                print('Square icon pressed');
              },
              icon: const Icon(
                Icons.photo_size_select_small, // Square icon
                color: Colors.white,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
