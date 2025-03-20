import 'package:flutter/material.dart';
import 'package:game/round1intro.dart';
import 'PlayerQuestionScreen.dart';

class QuestionsScreen extends StatelessWidget {
  final Map<String, int> teamData;

  const QuestionsScreen({super.key, required this.teamData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/b4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gradient "Mix Grill" Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    "Mix Grill",
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                Expanded(
                  child: ListView(
                    children: teamData.entries
                        .where((entry) => entry.value >= 2)
                        .map((entry) => _buildTeamSection(
                        context, entry.key, entry.value, screenWidth))
                        .toList(),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoundOneIntro(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, screenHeight * 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text("Submit All",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(
      BuildContext context, String teamName, int playerCount, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$teamName (Players: $playerCount)",
              style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: screenWidth * 0.02),
            ...List.generate(playerCount,
                    (index) => _buildPlayerButton(context, teamName, index, screenWidth)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerButton(
      BuildContext context, String teamName, int playerIndex, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerQuestionsScreen(
                teamName: teamName,
                playerIndex: playerIndex + 1,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, screenWidth * 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text("Player ${playerIndex + 1} Questions",
            style: TextStyle(fontSize: screenWidth * 0.040)),
      ),
    );
  }
}