import 'package:flutter/material.dart';
import 'package:game/game_data.dart';

class PlayerQuestionsScreen extends StatefulWidget {
  final String teamName;
  final int playerIndex;

  const PlayerQuestionsScreen({
    super.key,
    required this.teamName,
    required this.playerIndex,
  });

  @override
  State<PlayerQuestionsScreen> createState() => _PlayerQuestionsScreenState();
}

class _PlayerQuestionsScreenState extends State<PlayerQuestionsScreen> {
  final TextEditingController question1Controller = TextEditingController();
  final TextEditingController question2Controller = TextEditingController();
  final TextEditingController question3Controller = TextEditingController();
  final TextEditingController question4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (GameData.answers.containsKey(widget.teamName) &&
        GameData.answers[widget.teamName]!.containsKey(widget.playerIndex)) {
      List<String> playerAnswers = GameData.answers[widget.teamName]![widget.playerIndex]!;
      question1Controller.text = playerAnswers[0];
      question2Controller.text = playerAnswers[1];
      question3Controller.text = playerAnswers[2];
      question4Controller.text = playerAnswers[3];
    }
  }

  void _saveAnswers() {
    final answersList = [
      question1Controller.text,
      question2Controller.text,
      question3Controller.text,
      question4Controller.text
    ];

    if (!GameData.answers.containsKey(widget.teamName)) {
      GameData.answers[widget.teamName] = {};
    }
    GameData.answers[widget.teamName]![widget.playerIndex] = answersList;

    Navigator.pop(context); // Go back
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
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      "Mix Grill",
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "${widget.teamName} - Player ${widget.playerIndex}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _buildQuestionTextField("اسم شخصية عامة", question1Controller, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                  _buildQuestionTextField("فيلم", question2Controller, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                  _buildQuestionTextField("أغنية", question3Controller, screenWidth),
                  SizedBox(height: screenHeight * 0.02),
                  _buildQuestionTextField("مكان في مصر", question4Controller, screenWidth),
                  SizedBox(height: screenHeight * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveAnswers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      ),
                      child: Text(
                        "Submit and Next Player",
                        style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTextField(String label, TextEditingController controller, double screenWidth) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: const Color(0xFF070C1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.white70, fontSize: screenWidth * 0.036),
      ),
      style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
    );
  }
}