import 'package:flutter/material.dart';
import 'package:tmtdiseases/CustomBottomNavigationBar.dart';
import 'package:tmtdiseases/homePage.dart';

class ProjectTeamAndMembers extends StatefulWidget {
  const ProjectTeamAndMembers({super.key});

  @override
  _ProjectTeamAndMembersState createState() => _ProjectTeamAndMembersState();
}

class _ProjectTeamAndMembersState extends State<ProjectTeamAndMembers> {
  int _selectedIndex = 1; // Default index for 'Project Team and Members' page

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = 0; // Reset to Home index
      });
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Homepage(),
          transitionDuration: Duration.zero, // No animation duration
          reverseTransitionDuration: Duration.zero, // No reverse animation
        ),
        (route) => false, // Remove all previous routes
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Team and Members'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(12, 128, 77, 0.4),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'University',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/image/logo/logo-color.png',
                height: 150, // Adjust height
                width: 150, // Adjust width
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text(
                'University of Colombo Sri Lanka',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(12, 128, 77, 0.8),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Members :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "- B.L.P Sandaruwan   - 2019T00466\n"
                "- V.G.N.T Nlindra    - 2019T00459\n"
                '- K.A.S.N Mapalagama - 2019T00453',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(12, 128, 77, 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
