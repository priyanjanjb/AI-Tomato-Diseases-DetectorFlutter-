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
    "Early Blight": {
      "description":
          "A fungal disease-causing brown spots with concentric rings on older leaves, eventually leading to leaf drops and fruit rot.",
      "causes": [
        "Overhead watering.",
        "Warm, wet conditions.",
        "Infected plant debris left in the soil."
      ]
    },
    "Late Blight": {
      "description":
          "A fungal disease that causes dark, water-soaked spots on leaves and fruits, eventually leading to plant death.",
      "causes": [
        "Prolonged wet or humid conditions.",
        "Poor air circulation around plants.",
        "Infected seeds or transplants."
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
    "Spider Mites (Two-Spotted Spider Mite)": {
      "description":
          "Tiny pests that cause yellowing, speckled leaves, and fine webbing, eventually leading to leaf drop.",
      "causes": [
        "Hot, dry conditions.",
        "Lack of natural predators.",
        "Dusty, unclean growing environments."
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
    "healthy": {
      "description": "The plant is healthy and free from any diseases.",
      "causes": [
        "No known causes available.",
        "Keep up the good work!",
        "Continue to monitor plant health."
      ]
    }
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

      // Define output with shape [1, 10]
      var output = List<List<double>>.filled(1, List<double>.filled(10, 0.0));

      // Run inference with the input and output buffer
      _interpreter.run(input, output);

      // Access the predicted class index from output[0]
      var predictedClassIndex =
          output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
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

  // Preprocess image to extract RGB values properly
  Future<List<List<List<List<double>>>>> _preprocessImage(
      List<int> imageBytes) async {
    try {
      img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));
      if (image == null) {
        print("Failed to decode image.");
        return List.generate(
            1,
            (_) => List.generate(
                256,
                (_) =>
                    List.generate(256, (_) => List.generate(3, (_) => 0.0))));
      }
      img.Image resizedImage = img.copyResize(image, width: 256, height: 256);

      List<List<List<List<double>>>> normalizedImage = List.generate(
        1,
        (batchIndex) => List.generate(
          256,
          (i) => List.generate(
            256,
            (j) {
              int rgb = resizedImage.getPixel(j, i) as int;
              double red = ((rgb >> 16) & 0xFF) / 255.0;
              double green = ((rgb >> 8) & 0xFF) / 255.0;
              double blue = (rgb & 0xFF) / 255.0;
              return [red, green, blue];
            },
          ),
        ),
      );

      return normalizedImage;
    } catch (e) {
      print("Error during image preprocessing: $e");
      return List.generate(
          1,
          (_) => List.generate(256,
              (_) => List.generate(256, (_) => List.generate(3, (_) => 0.0))));
    }
  }

  String getFormattedDiseaseName(String diseaseName) {
    switch (diseaseName) {
      case 'Bacterial_spot':
        return 'Bacterial Spot';
      case 'Early_blight':
        return 'Early Blight';
      case 'Late_blight':
        return 'Late Blight';
      case 'Leaf_Mold':
        return 'Leaf Mold';
      case 'Septoria_leaf_spot':
        return 'Septoria Leaf Spot';
      case 'Spider_Mites_(Two-Spotted_Spider_Mite)':
        return 'Spider Mites (Two-Spotted Spider Mite)';
      case 'Target_Spot':
        return 'Target Spot';
      case 'Yellow_Leaf_Curl_Virus':
        return 'Tomato Yellow Leaf Curl Virus';
      case 'Mosaic_virus':
        return 'Tomato Mosaic Virus';
      case 'Healthy':
        return 'healthy';
      default:
        return diseaseName;
    }
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
        ? getFormattedDiseaseName(_predictions![0].toString())
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
}
