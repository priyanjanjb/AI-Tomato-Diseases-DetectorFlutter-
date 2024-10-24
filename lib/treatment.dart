import 'package:flutter/material.dart';
import 'package:tmtdiseases/chatInterface.dart';

class Treatment extends StatelessWidget {
  const Treatment({super.key});

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
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SizedBox(
                      width: 345,
                      child: Column(children: [
                        Divider(
                          color: Colors.grey, // Line color
                          thickness: 1, // Line thickness
                        ),
                        Text(
                          "Treatment for Bacterial Spot",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                        Divider(
                          color: Colors.grey, // Line color
                          thickness: 1, // Line thickness
                        ),
                        Text("Conventional Treatment:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromRGBO(16, 26, 173, 1))),
                        ListBody(
                          children: [
                            Text("Lorem Ipsum is simply dummy text of "),
                            Text("Lorem Ipsum is simply dummy text of "),
                            Text("Lorem Ipsum is simply dummy text of "),
                          ],
                        ),
                        Divider(
                          color: Colors.grey, // Line color
                          thickness: 1, // Line thickness
                          indent: 20, // Left margin
                          endIndent: 20, // Right margin
                        ),
                        Text("Organic Treatment:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromRGBO(16, 26, 173, 1))),
                        ListBody(
                          children: [
                            Text("Lorem Ipsum is simply dummy text of "),
                            Text("Lorem Ipsum is simply dummy text of "),
                            Text("Lorem Ipsum is simply dummy text of "),
                          ],
                        )
                      ]),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
