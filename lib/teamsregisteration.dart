import 'package:flutter/material.dart';
import 'package:game/QuestionsScreen.dart';
import 'package:game/game_data.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  int team1Players = 0;
  int team2Players = 0;
  int team3Players = 0;
  int team4Players = 0;

  final List<int> playerOptions = [0, 1, 2, 3, 4];

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
            image: AssetImage("assets/b4.jpg"), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
            child: Column(
              children: [
                // Mix Grill Title with Gradient Effect
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    "Mix Grill",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Team Selection Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownRow("Team 1", team1Players, (value) {
                        setState(() => team1Players = value!);
                      }),
                      _buildDropdownRow("Team 2", team2Players, (value) {
                        setState(() => team2Players = value!);
                      }),
                      _buildDropdownRow("Team 3", team3Players, (value) {
                        setState(() => team3Players = value!);
                      }),
                      _buildDropdownRow("Team 4", team4Players, (value) {
                        setState(() => team4Players = value!);
                      }),
                    ],
                  ),
                ),

                // Start Button
                ElevatedButton(
                  onPressed: () {
                    GameData.teams = [];
                    if (team1Players >= 2) GameData.teams.add("Team 1");
                    if (team2Players >= 2) GameData.teams.add("Team 2");
                    if (team3Players >= 2) GameData.teams.add("Team 3");
                    if (team4Players >= 2) GameData.teams.add("Team 4");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionsScreen(
                          teamData: {
                            'Team 1': team1Players,
                            'Team 2': team2Players,
                            'Team 3': team3Players,
                            'Team 4': team4Players,
                          },
                        ),
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
                  child: const Text("Start Game", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dropdown Builder
  Widget _buildDropdownRow(String teamName, int currentValue, ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              teamName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            DropdownButton<int>(
              value: currentValue,
              dropdownColor: Colors.blueGrey,
              items: playerOptions
                  .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option.toString(), style: const TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: onChanged,
              underline: Container(height: 2, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
