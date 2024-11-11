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
    },
    "Healthy": {
      "description":
          "The plant appears to be healthy with no signs of disease.",
      "causes": ["N/A"]
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
      // Decode the image from bytes
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
      // Resize the image to the target size (256x256)
      img.Image resizedImage = img.copyResize(image, width: 256, height: 256);

      // Normalize pixel data
      List<List<List<List<double>>>> normalizedImage = List.generate(
        1,
        (batchIndex) => List.generate(
          256,
          (i) => List.generate(
            256,
            (j) {
              // Retrieve the RGB value from the pixel
              int rgb = resizedImage.getPixel(j, i) as int;

              // Extract and normalize RGB values from the pixel
              double red = ((rgb >> 16) & 0xFF) / 255.0;
              double green = ((rgb >> 8) & 0xFF) / 255.0;
              double blue = (rgb & 0xFF) / 255.0;

              // Return the normalized RGB values as a list for this pixel
              return [red, green, blue];
            },
          ),
        ),
      );

      return normalizedImage; // Returning the full normalized image with batch dimension
    } catch (e) {
      print("Error during image preprocessing: $e");
      // Return a default image in case of error
      return List.generate(
          1,
          (_) => List.generate(256,
              (_) => List.generate(256, (_) => List.generate(3, (_) => 0.0))));
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
