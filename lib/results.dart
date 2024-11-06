import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tmtdiseases/treatment.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
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

  final Map<String, Map<String, dynamic>> diseaseDetails = {
    "Late Blight": {
      "description":
          "A fungal disease that causes dark, water-soaked spots on leaves and fruits, eventually leading to plant death.",
      "causes": [
        "Prolonged wet or humid conditions.",
        "Poor air circulation around plants.",
        "Infected seeds or transplants."
      ]
    },
    "Target Spot": {
      "description":
          "Dark, sunken lesions with concentric rings on leaves and fruits, causing premature leaf drop.",
      "causes": [
        "Warm, moist weather.",
        "Poor sanitation of plant debris.",
        "Overcrowded planting leads to reduced airflow."
      ]
    },
    "Tomato Yellow Leaf Curl Virus": {
      "description":
          "A viral disease causing yellowing and curling of leaves, stunted growth, and reduced fruit production.",
      "causes": [
        "Transmission by whiteflies.",
        "Presence of infected plants nearby.",
        "Poor pest management."
      ]
    },
    "Tomato Mosaic Virus": {
      "description":
          "A viral infection causing mottled or mosaic patterns on leaves, distorted fruit, and stunted growth.",
      "causes": [
        "Handling infected plants.",
        "Contaminated tools or hands.",
        "Seed-borne transmission."
      ]
    },
    "Early Blight": {
      "description":
          "A fungal disease-causing brown spots with concentric rings on older leaves, eventually leading to leaf drops and fruit rot.",
      "causes": [
        "Overhead watering.",
        "Warm, wet conditions.",
        "Infected plant debris left in the soil."
      ]
    },
    "Spider Mites (Two-Spotted Spider Mite)": {
      "description":
          "Tiny pests that cause yellowing, speckled leaves, and fine webbing, eventually leading to leaf drop.",
      "causes": [
        "Hot, dry conditions.",
        "Lack of natural predators.",
        "Dusty, unclean growing environments."
      ]
    },
    "Leaf Mold": {
      "description":
          "A fungal disease causing pale green or yellow spots on the upper leaf surface, with velvety gray mold underneath.",
      "causes": [
        "High humidity and poor ventilation.",
        "Water splashing on leaves.",
        "Infected plant material."
      ]
    },
    "Septoria Leaf Spot": {
      "description":
          "Fungal disease causing small, circular spots with gray centers and dark borders on leaves, leading to early defoliation.",
      "causes": [
        "Warm, wet weather.",
        "Infected seeds or plants.",
        "Water splashing from the soil onto leaves."
      ]
    },
    "Bacterial Spot": {
      "description":
          "A bacterial disease that causes small, water-soaked spots on leaves and fruits, leading to leaf yellowing and fruit blemishes.",
      "causes": [
        "Contaminated seeds or transplants.",
        "Warm, wet conditions.",
        "Splashing water from rain or irrigation."
      ]
    }
  };

  List<String> diseaseLabels = [
    "Late Blight",
    // Add other labels...
  ];

  @override
  void initState() {
    super.initState();
    loadModel();
    runModelOnImage();
  }

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/model/tomatodiseas.tflite');
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> runModelOnImage() async {
    var inputImage = File(widget.imagePath).readAsBytesSync();
    var input = await _preprocessImage(inputImage);

    var output = List<double>.filled(10, 0.0);
    try {
      _interpreter.run(input, output);
      print("Inference result: $output");

      var predictedClassIndex =
          output.indexOf(output.reduce((a, b) => a > b ? a : b));
      var predictedLabel = diseaseLabels[predictedClassIndex];
      var confidence = output[predictedClassIndex];

      setState(() {
        _predictions = [predictedLabel, confidence];
        _isLoading = false;
      });
    } catch (e) {
      print("Error running inference: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<List<List<double>>>> _preprocessImage(
      List<int> imageBytes) async {
    img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));
    if (image == null) {
      return List.generate(
          1, (_) => List.generate(224, (_) => List.generate(224, (_) => 0.0)));
    }

    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
    List<List<List<double>>> normalizedImage = List.generate(224, (i) {
      return List.generate(224, (j) {
        int pixel = resizedImage.getPixel(j, i) as int;
        return [
          (pixel & 0xFF) / 255.0,
          ((pixel >> 8) & 0xFF) / 255.0,
          ((pixel >> 16) & 0xFF) / 255.0
        ];
      });
    });

    return normalizedImage;
  }

  @override
  Widget build(BuildContext context) {
    // Default values
    final String defaultDiseaseName = "No Disease Detected";
    final String defaultConfidence = "0.00";
    final String defaultDescription = "No description available.";
    final List<String> defaultCauses = ["No known causes available."];

// Use prediction data or default values
    final String diseaseName = _predictions != null && _predictions!.isNotEmpty
        ? _predictions![0].toString()
        : defaultDiseaseName;

    final String confidence = _predictions != null && _predictions!.isNotEmpty
        ? (100 * (_predictions![1] as double)).toStringAsFixed(2)
        : defaultConfidence;

// Get the disease description, or use the default if not found
    final String description = diseaseDetails.containsKey(diseaseName)
        ? (diseaseDetails[diseaseName]?['description'] ?? defaultDescription)
        : defaultDescription;

// Get the disease causes list, or use the default if not found
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
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
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Prediction: $diseaseName",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Text(
                            "Confidence: $confidence%",
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Description:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Causes:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          ...causes.map((cause) => Text("- $cause")),
                        ],
                      ),
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
