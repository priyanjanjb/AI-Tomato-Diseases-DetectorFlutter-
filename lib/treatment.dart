import 'package:flutter/material.dart';
import 'package:tmtdiseases/chatInterface.dart';

class Treatment extends StatelessWidget {
  final String disease;
  const Treatment({super.key, required this.disease});

  // Define the treatments for each disease using switch-case
  Map<String, List<String>> getTreatments(String disease) {
    switch (disease) {
      case 'Bacterial Spot':
        return {
          'Conventional': [
            'Use fungicides containing copper or chlorothalonil.',
            'Ensure proper plant spacing for air circulation.',
          ],
          'Organic': [
            'Apply neem oil or baking soda spray.',
            'Remove infected leaves promptly.',
          ],
        };
      case 'Early Blight':
        return {
          'Conventional': [
            'Use insecticides to control whiteflies.',
            'Plant resistant varieties.',
          ],
          'Organic': [
            'Introduce natural predators like ladybugs.',
            'Use sticky traps to control whiteflies.',
          ],
        };
      case 'healthy':
        return {
          'Conventional': [
            'Ensure proper fertilization and pest control.',
            'Practice preventive fungicide application.',
          ],
          'Organic': [
            'Enhance soil health with compost.',
            'Use companion planting for natural pest deterrence.',
          ],
        };
      case 'Late Blight':
        return {
          'Conventional': [
            'Apply fungicides like mancozeb or chlorothalonil.',
            'Remove and destroy infected plants.',
          ],
          'Organic': [
            'Spray plants with a solution of baking soda and water.',
            'Rotate crops to prevent recurrence.',
          ],
        };
      case 'Leaf Mold':
        return {
          'Conventional': [
            'Apply fungicides such as captan or mancozeb.',
            'Ensure proper ventilation in greenhouses.',
          ],
          'Organic': [
            'Use sulfur-based sprays.',
            'Prune lower leaves to improve airflow.',
          ],
        };
      case 'Mosaic Virus':
        return {
          'Conventional': [
            'Remove and destroy infected plants immediately.',
            'Use virus-free seeds.',
          ],
          'Organic': [
            'Control aphids with neem oil.',
            'Promote soil health to enhance plant resistance.',
          ],
        };
      case 'Septoria Leaf Spot':
        return {
          'Conventional': [
            'Use copper-based fungicides.',
            'Remove infected leaves to reduce spread.',
          ],
          'Organic': [
            'Apply compost tea to boost plant immunity.',
            'Mulch around plants to prevent soil splash.',
          ],
        };
      case 'Tomato Yellow Leaf Curl Virus':
        return {
          'Conventional': [
            'Use insecticides to control whiteflies.',
            'Plant resistant tomato varieties.',
          ],
          'Organic': [
            'Introduce beneficial insects like ladybugs.',
            'Use reflective mulches to deter whiteflies.',
          ],
        };
      default:
        return {
          'Conventional': ['No specific treatment available!.'],
          'Organic': ['No specific treatment available!.'],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch treatments using the switch-case method
    final diseaseTreatment = getTreatments(disease);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Treatments',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Treatment for $disease",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 16),
              // Display Conventional Treatments
              Text(
                "Conventional Treatments:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(16, 26, 173, 1),
                ),
              ),
              const SizedBox(height: 8),
              ...diseaseTreatment['Conventional']!.map((treatment) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "- $treatment",
                      style: const TextStyle(fontSize: 16),
                    ),
                  )),
              const SizedBox(height: 16),
              // Display Organic Treatments
              Text(
                "Organic Treatments:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(16, 26, 173, 1),
                ),
              ),
              const SizedBox(height: 8),
              ...diseaseTreatment['Organic']!.map((treatment) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "- $treatment",
                      style: const TextStyle(fontSize: 16),
                    ),
                  )),
              const Spacer(),
              // Chat Button
              Center(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Chatinterface()),
                    );
                  },
                  backgroundColor: const Color.fromRGBO(12, 128, 77, 0.8),
                  label: const Text(
                    "Chat With Us",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
