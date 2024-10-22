import 'package:flutter/material.dart';
import 'package:tmtdiseases/treatment.dart';

class Results extends StatelessWidget {
  const Results({super.key});

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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: 250,
                        width: 210,
                        color: const Color.fromARGB(255, 221, 221, 221),
                        child: const Column(
                          children: [
                            Text("Results Photo 01"),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0, bottom: 8.0),
                      child: Container(
                        height: 250,
                        width: 140,
                        color: const Color.fromARGB(255, 221, 221, 221),
                        child: const Column(
                          children: [
                            Text("Results Photo 02"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SizedBox(
                      width: 345,
                      child: Column(children: [
                        Text("Lorem ipsem dolor sit amet."),
                        Text(
                          "Bacterial spot symptoms",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                        Text("Causes:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25)),
                        ListBody(
                          children: [
                            Text("Lorem Ipsum is simply dummy text of "),
                            Text("Lorem Ipsum is simply dummy text of "),
                            Text("Lorem Ipsum is simply dummy text of "),
                          ],
                        ),
                      ]),
                    ),
                  )
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
                                builder: (context) => const Treatment()));
                      },
                      label: const Text("Treatments",
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
}
