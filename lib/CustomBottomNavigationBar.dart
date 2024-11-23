import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            if (selectedIndex == 0) // Show the green line above "Home"
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 160.0), // Adjust for "Home"
                  child: Container(
                    height: 4,
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.green,
                  ),
                ),
              ),
            if (selectedIndex == 1) // Show the green line above "Question Mark"
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 160.0), // Adjust for "Question Mark"
                  child: Container(
                    height: 4,
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
        BottomNavigationBar(
          currentIndex: selectedIndex,
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
          onTap: onItemTapped,
        ),
      ],
    );
  }
}
