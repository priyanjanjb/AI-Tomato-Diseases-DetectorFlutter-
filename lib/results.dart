import 'dart:io'; // To work with File for displaying images
import 'package:flutter/material.dart';
import 'package:tmtdiseases/treatment.dart';
import 'package:tflite/tflite.dart';

class Results extends StatefulWidget {
  final String imagePath;

  const Results({super.key, required this.imagePath});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
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

  // Load the model
  Future<void> loadModel() async {
    String? result = await Tflite.loadModel(
      model: "assets/model.tflite", // Replace with your model path
      labels: "assets/labels.txt", // Replace with your labels path
    );
    print("Model loaded: $result");
  }

  // Run the model on the image and get predictions
  Future<void> runModelOnImage() async {
    var predictions = await Tflite.runModelOnImage(
      path: widget.imagePath, // Path to the image
      imageMean: 0.0, // Defaults to 0.0; set based on your model
      imageStd: 255.0, // Defaults to 255.0; set based on your model
      numResults: 3, // Limit the number of results
      threshold: 0.5, // Confidence threshold
    );

    setState(() {
      _predictions = predictions;
      _isLoading = false;
    });

    // Debugging: Print the predictions to check the model output
    print("Predictions: $_predictions");
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
              // Display the selected image
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

              // Loading indicator or result display
              _isLoading
                  ? const CircularProgressIndicator()
                  : _predictions != null && _predictions!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display prediction label and confidence
                              Text(
                                "Prediction: ${_predictions![0]['label']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                "Confidence: ${(_predictions![0]['confidence'] * 100).toStringAsFixed(2)}%",
                              ),
                              const SizedBox(height: 10),

                              // Check if the prediction label exists in the diseaseDetails map
                              if (diseaseDetails
                                  .containsKey(_predictions![0]['label']))
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
                                        ['label']]?['description']),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Causes:",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    ...diseaseDetails[_predictions![0]['label']]
                                            ?['causes']
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

              // Treatment button
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
    Tflite.close();
    super.dispose();
  }
}
