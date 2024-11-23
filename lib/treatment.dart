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
            'Use copper-based bactericides.',
          ],
          'Organic': [
            'Spray with a mixture of copper and hydrated lime; increase plant spacing.',
          ],
        };
      case 'Early Blight':
        return {
          'Conventional': [
            'Apply fungicides like mancozeb or azoxystrobin.',
          ],
          'Organic': [
            'Spray sulfur-based products or compost tea; prune lower leaves.',
          ],
        };
      case 'healthy':
        return {
          'Conventional': [
            'keep the plant healthy.',
          ],
          'Organic': [
            'keep the plant healthy.',
          ],
        };
      case 'Late Blight':
        return {
          'Conventional': [
            ' Use fungicides containing chlorothalonil or mancozeb.',
          ],
          'Organic': [
            'Apply copper-based fungicides or neem oil; ensure good air circulation.',
          ],
        };
      case 'Leaf Mold':
        return {
          'Conventional': [
            'Apply fungicides like chlorothalonil.',
          ],
          'Organic': [
            ' Increase ventilation; use baking soda sprays or milk sprays.',
          ],
        };
      case 'Mosaic Virus':
        return {
          'Conventional': [
            'Remove infected plants; sanitize tools regularly.',
          ],
          'Organic': [
            'Use resistant varieties; apply seaweed extract to boost plant immunity.',
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
            'Use insecticides to control whiteflies (e.g., imidacloprid).',
          ],
          'Organic': [
            ' Introduce natural predators (ladybugs) and use yellow sticky traps.',
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
