// ignore: file_names
import 'package:flutter/material.dart';
import 'package:tmtdiseases/camera.dart';
import 'package:tmtdiseases/chatInterface.dart';
import 'package:tmtdiseases/results.dart';
import 'package:tmtdiseases/treatment.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Image(
              image: AssetImage(
                  'assets/image/logo/_Green Simple Nature Beauty Care Initials Logo  (1).png'),
              width: 100,
              height: 100),
        )),
        backgroundColor: const Color.fromRGBO(12, 128, 77, 0.4),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Chatinterface()),
                );
              },
              child: Container(
                height: 100,
                width: 350,
                color: const Color.fromARGB(255, 221, 221, 221),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: [
                            Text(
                              "Health Check",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Quickly identify diseases",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 50.0),
                        child: Image(
                          image: AssetImage('assets/image/icons/Picture1.png'),
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Treatment()),
                  );
                },
                child: Container(
                  height: 100,
                  width: 350,
                  color: const Color.fromARGB(255, 221, 221, 221),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                "Treatment",
                                style: const TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Treatment for diseases",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50.0),
                          child: Image(
                            image:
                                AssetImage('assets/image/icons/Picture2.png'),
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                        MaterialPageRoute(builder: (context) => const Camera()),
                      );
                    },
                    backgroundColor: const Color.fromRGBO(12, 128, 77, 0.8),
                    label: const Text(
                      "Health Check",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromRGBO(18, 7, 141, 1),
              size: 35,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.question_mark_sharp,
              color: Color.fromRGBO(18, 7, 141, 1),
              size: 35,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
