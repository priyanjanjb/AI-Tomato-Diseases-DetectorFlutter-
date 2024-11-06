import 'package:flutter/material.dart';
import 'package:tmtdiseases/chatInterface.dart';

class Treatment extends StatelessWidget {
  final String disease;

  const Treatment({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Treatments')),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      width: 345,
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Text(
                            "Treatment for $disease", // Display the disease dynamically
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          const Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry."),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          const Text("Conventional Treatment:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Color.fromRGBO(16, 26, 173, 1))),
                          const ListBody(
                            children: [
                              Text("Lorem Ipsum is simply dummy text of "),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                          const Text("Organic Treatment:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Color.fromRGBO(16, 26, 173, 1))),
                          const ListBody(
                            children: [
                              Text("Lorem Ipsum is simply dummy text of "),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
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
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
