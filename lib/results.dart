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
  List<dynamic>? _predictions; // To store predictions from the model
  bool _isLoading =
      true; // To show loading indicator while predictions are being processed

  // A map of disease details to be displayed for each disease
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
    // ... (Other diseases go here)
  };

  @override
  void initState() {
    super.initState();
    loadModel(); // Load the model when the widget is initialized
    runModelOnImage(); // Run the model on the image once initialized
  }

  // Load the model from assets
  Future<void> loadModel() async {
    // Try loading the model and print the result for debugging
    String? result = await Tflite.loadModel(
      model: "assets/model.tflite", // Path to your model
      labels: "assets/labels.txt", // Path to your labels file
    );
    print("Model loaded: $result"); // Ensure the model is loaded successfully
  }

  // Run the model on the selected image to make predictions
  Future<void> runModelOnImage() async {
    // Ensure the image path is correct and accessible
    var predictions = await Tflite.runModelOnImage(
      path: widget.imagePath, // Path to the image
      imageMean:
          0.0, // Mean normalization (Adjust based on your model's requirement)
      imageStd:
          255.0, // Standard deviation normalization (Adjust based on your model)
      numResults: 3, // Number of results to return
      threshold: 0.5, // Confidence threshold for predictions
    );

    print("Predictions: $predictions"); // Print predictions for debugging

    // Update the state with predictions once the model has run
    setState(() {
      _predictions = predictions; // Store predictions
      _isLoading = false; // Hide loading spinner once predictions are available
    });
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
                              File(widget
                                  .imagePath), // Display the selected image
                              height: 250,
                              width: 280,
                              fit: BoxFit.cover,
                            )
                          : const Text(
                              'No Image Selected'), // Handle case when no image is selected
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator if still loading
                  : _predictions != null && _predictions!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Prediction: ${_predictions![0]['label']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                "Confidence: ${(_predictions![0]['confidence'] * 100).toStringAsFixed(2)}%",
                              ),
                              const SizedBox(height: 10),
                              // Display disease details if predictions are available
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
                                    "Details not found for this disease."), // If disease details are not found
                            ],
                          ),
                        )
                      : const Text(
                          "No disease detected or low confidence in results."), // If no predictions
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        // Navigate to treatment page if available
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
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Close the TFLite model when the widget is disposed
    Tflite.close();
    super.dispose();
  }
}
