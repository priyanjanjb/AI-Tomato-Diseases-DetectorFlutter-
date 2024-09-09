import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('LOGO')),
        backgroundColor: Colors.green,
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Helth Check",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Quickly identify diseases",
                      style: TextStyle(fontSize: 15),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [Text("Icon", style: TextStyle(fontSize: 30))],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Treatment",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Treatment for diseases",
                      style: TextStyle(fontSize: 15),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [Text("Icon", style: TextStyle(fontSize: 30))],
                  ),
                )
              ],
            ),
            Row(
              children: [
                FloatingActionButton.extended(
                    onPressed: null,
                    backgroundColor: Color.fromARGB(255, 34, 177, 106),
                    label: Text("Helth check",
                        style: TextStyle(fontSize: 30, color: Colors.white))),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: Color.fromARGB(207, 0, 26, 255), size: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_sharp,
                color: Color.fromARGB(207, 0, 26, 255), size: 35),
            label: '',
          ),
        ],
      ),
    );
  }
}
