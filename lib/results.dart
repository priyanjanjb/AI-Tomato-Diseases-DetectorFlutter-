import 'package:flutter/material.dart';

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
                    padding: EdgeInsets.only(left: 15.0 ,right: 15.0),
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
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                      ]),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
