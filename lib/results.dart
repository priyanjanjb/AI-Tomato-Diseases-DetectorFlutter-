import 'dart:io'; // To work with File for displaying images
import 'package:flutter/material.dart';
import 'package:tmtdiseases/treatment.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Results extends StatefulWidget {
  final String imagePath;

  const Results({super.key, required this.imagePath});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  Interpreter? _interpreter;
  List<dynamic>? _predictions;
  bool _isLoading = true;

  // Map holding the disease details
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

  @override
  void initState() {
    super.initState();
    loadModel();
    runModelOnImage();
  }

  // Load the model using tflite_flutter package
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Run the model on the image and get predictions
  Future<void> runModelOnImage() async {
    if (_interpreter == null) return;

    // Preprocess the image to match the model input requirements
    var inputImage = await processImage(widget.imagePath);
    var output = List.filled(1 * 2, 0).reshape([1, 2]);

    _interpreter!.run(inputImage, output);

    setState(() {
      _predictions = output;
      _isLoading = false;
    });

    print("Predictions: $_predictions");
  }

  // Helper function to process the image for inference
  Future<List<List<double>>> processImage(String imagePath) async {
    // Implement image preprocessing to match your model's input
    // This should resize the image and normalize it as per model requirements
    // Example: Assuming input is a 1x5 list
    return [
      [1.23, 6.54, 7.81, 3.21, 2.22]
    ]; // Placeholder data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Results')),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 250,
                      width: 210,
                      color: const Color.fromARGB(255, 221, 221, 221),
                      child: widget.imagePath.isNotEmpty
                          ? Image.file(
                              File(widget.imagePath),
                              height: 250,
                              width: 280,
                              fit: BoxFit.cover,
                            )
                          : const Text('No Image Selected'),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : _predictions != null && _predictions!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Prediction: ${_predictions![0]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                "Confidence: ${(_predictions![1] * 100).toStringAsFixed(2)}%",
                              ),
                              const SizedBox(height: 10),
                              if (diseaseDetails
                                  .containsKey(_predictions![0].toString()))
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description:",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(diseaseDetails[_predictions![0]
                                        .toString()]?['description']),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Causes:",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    ...diseaseDetails[_predictions![0]
                                            .toString()]?['causes']
                                        .map<Widget>(
                                            (cause) => Text("- $cause"))
                                        .toList(),
                                  ],
                                )
                              else
                                const Text(
                                    "Details not found for this disease."),
                            ],
                          ),
                        )
                      : const Text(
                          "No disease detected or low confidence in results."),
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
                                builder: (context) => const Treatment()));
                      },
                      label: const Text("Treatment",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
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
    _interpreter?.close();
    super.dispose();
  }
}
