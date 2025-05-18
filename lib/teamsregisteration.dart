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

  // Text controllers for team names
  final TextEditingController team1NameController =
      TextEditingController(text: "Team 1");
  final TextEditingController team2NameController =
      TextEditingController(text: "Team 2");
  final TextEditingController team3NameController =
      TextEditingController(text: "Team 3");
  final TextEditingController team4NameController =
      TextEditingController(text: "Team 4");

  final List<int> playerOptions = [0, 1, 2, 3];

  @override
  void dispose() {
    // Dispose text controllers to prevent memory leaks
    team1NameController.dispose();
    team2NameController.dispose();
    team3NameController.dispose();
    team4NameController.dispose();
    super.dispose();
  }

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
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
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
                      fontFamily: 'Pacifico', // Modern font
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Decorative Line
                Container(
                  width: screenWidth * 0.3,
                  height: 2,
                  color: Colors.white.withAlpha(128),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Subtitle with Improved Typography
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    "اختار عدد اللاعبين و اسم كل فريق",
                    textAlign: TextAlign.center, // Move textAlign here
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      shadows: const [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Team Selection Section
                Expanded(
                  child: ListView(
                    children: [
                      _buildTeamRow("1", team1NameController, team1Players,
                          (value) {
                        setState(() => team1Players = value!);
                      }),
                      _buildTeamRow("2", team2NameController, team2Players,
                          (value) {
                        setState(() => team2Players = value!);
                      }),
                      _buildTeamRow("3", team3NameController, team3Players,
                          (value) {
                        setState(() => team3Players = value!);
                      }),
                      _buildTeamRow("4", team4NameController, team4Players,
                          (value) {
                        setState(() => team4Players = value!);
                      }),
                    ],
                  ),
                ),

                // Start Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                  child: ElevatedButton(
                    onPressed: () {
                      GameData.teams = [];

                      // Add teams only if they have at least 2 players
                      if (team1Players >= 2)
                        GameData.teams.add(
                            team1NameController.text.trim().isNotEmpty
                                ? team1NameController.text
                                : "Team 1");
                      if (team2Players >= 2)
                        GameData.teams.add(
                            team2NameController.text.trim().isNotEmpty
                                ? team2NameController.text
                                : "Team 2");
                      if (team3Players >= 2)
                        GameData.teams.add(
                            team3NameController.text.trim().isNotEmpty
                                ? team3NameController.text
                                : "Team 3");
                      if (team4Players >= 2)
                        GameData.teams.add(
                            team4NameController.text.trim().isNotEmpty
                                ? team4NameController.text
                                : "Team 4");

                      // Show error if no teams are selected
                      if (GameData.teams.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'يجب اختيار فريق واحد على الأقل مع عدد لاعبين لا يقل عن 2'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionsScreen(
                            teamData: {
                              team1NameController.text.trim().isNotEmpty
                                  ? team1NameController.text
                                  : "Team 1": team1Players,
                              team2NameController.text.trim().isNotEmpty
                                  ? team2NameController.text
                                  : "Team 2": team2Players,
                              team3NameController.text.trim().isNotEmpty
                                  ? team3NameController.text
                                  : "Team 3": team3Players,
                              team4NameController.text.trim().isNotEmpty
                                  ? team4NameController.text
                                  : "Team 4": team4Players,
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, screenHeight * 0.07),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 8,
                      shadowColor: Colors.lightBlueAccent.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded, size: 28),
                        const SizedBox(width: 10),
                        const Text(
                          "Start Game",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Remove this extra closing parenthesis
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Team Row Builder with Name TextField and Player Dropdown
  Widget _buildTeamRow(String teamNumber, TextEditingController nameController,
      int currentValue, ValueChanged<int?> onChanged) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Team $teamNumber",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Enter team name",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: Colors.white.withOpacity(0.8)),
                  const SizedBox(width: 8),
                  const Text(
                    "Players:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<int>(
                  value: currentValue,
                  dropdownColor: Colors.blueGrey.shade700,
                  items: playerOptions.map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(
                      option.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )).toList(),
                  onChanged: onChanged,
                  underline: Container(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
