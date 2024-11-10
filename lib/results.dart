import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tmtdiseases/treatment.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class Results extends StatefulWidget {
  final String imagePath;

  const Results({super.key, required this.imagePath});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  List<dynamic>? _predictions;
  bool _isLoading = true;

  late Interpreter _interpreter;

  List<String> diseaseLabels = [
    'Bacterial_spot',
    'Early_blight',
    'Late_blight',
    'Leaf_Mold',
    'Septoria_leaf_spot',
    'Spider_Mites_(Two-Spotted_Spider_Mite)',
    'Target_Spot',
    'Yellow_Leaf_Curl_Virus',
    'Mosaic_virus',
    'Healthy'
  ];

  final Map<String, Map<String, dynamic>> diseaseDetails = {
    "Bacterial Spot": {
      "description":
          "A bacterial disease that causes small, water-soaked spots on leaves and fruits, leading to leaf yellowing and fruit blemishes.",
      "causes": [
        "Contaminated seeds or transplants.",
        "Warm, wet conditions.",
        "Splashing water from rain or irrigation."
      ]
    },
    // Add remaining details...
  };

  @override
  void initState() {
    super.initState();
    if (widget.imagePath.isNotEmpty) {
      loadModel();
    } else {
      setState(() => _isLoading = false);
      print("Image path is empty.");
    }
  }

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/model/tomatodiseas.tflite');
      print("Model loaded successfully.");
      runModelOnImage();
    } catch (e) {
      print("Error loading model: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> runModelOnImage() async {
    setState(() => _isLoading = true);

    try {
      var inputImage = File(widget.imagePath).readAsBytesSync();
      var input = await _preprocessImage(inputImage);

      if (input.isEmpty) {
        print("Error: Preprocessed input is empty.");
        setState(() => _isLoading = false);
        return;
      }

      var output = List<double>.filled(diseaseLabels.length, 0.0);
      _interpreter.run(input, output);

      var predictedClassIndex =
          output.indexOf(output.reduce((a, b) => a > b ? a : b));
      var predictedLabel = diseaseLabels[predictedClassIndex];

      setState(() {
        _predictions = [predictedLabel];
        _isLoading = false;
      });
    } catch (e) {
      print("Error running inference: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<List<List<List<double>>>> _preprocessImage(
      List<int> imageBytes) async {
    img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));
    if (image == null) {
      print("Failed to decode image.");
      return List.generate(
          1, (_) => List.generate(256, (_) => List.generate(256, (_) => 0.0)));
    }

    img.Image resizedImage = img.copyResize(image, width: 256, height: 256);

    List<List<List<double>>> normalizedImage = List.generate(256, (i) {
      return List.generate(256, (j) {
        int pixel = resizedImage.getPixel(j, i) as int;

        double red = ((pixel >> 16) & 0xFF) / 255.0;
        double green = ((pixel >> 8) & 0xFF) / 255.0;
        double blue = (pixel & 0xFF) / 255.0;

        return [red, green, blue];
      });
    });

    return normalizedImage;
  }

  @override
  Widget build(BuildContext context) {
    final String defaultDiseaseName = "Not detected";
    final String defaultDescription =
        "The disease could not be detected. Please try again with a different image.";
    final List<String> defaultCauses = [
      "The image quality may be too low.",
      "The image may not contain a plant leaf.",
      "The model may not have been able to detect the disease."
    ];

    final String diseaseName = _predictions != null && _predictions!.isNotEmpty
        ? _predictions![0].toString()
        : defaultDiseaseName;

    final String description = diseaseDetails.containsKey(diseaseName)
        ? (diseaseDetails[diseaseName]?['description'] ?? defaultDescription)
        : defaultDescription;

    final List<String> causes = diseaseDetails.containsKey(diseaseName)
        ? List<String>.from(
            diseaseDetails[diseaseName]?['causes'] ?? defaultCauses)
        : defaultCauses;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Results')),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    Container(
                      height: 250,
                      width: 210,
                      color: Colors.grey[300],
                      child: widget.imagePath.isNotEmpty
                          ? Image.file(
                              File(widget.imagePath),
                              height: 250,
                              width: 210,
                              fit: BoxFit.cover,
                            )
                          : const Center(child: Text('No Image Selected')),
                    ),
                    Text(
                      "We’re highly confident that it is:",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      diseaseName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Description:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(description, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text(
                      "Causes:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    ...causes.map((cause) => Text("- $cause")),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Treatment(
                              disease: diseaseName,
                            ),
                          ),
                        );
                      },
                      label: const Text(
                        "Treatment",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      backgroundColor: const Color.fromRGBO(12, 128, 77, 0.8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }
}
