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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/b4.jpg"), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Colors.cyan, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: const Text(
                            "Mix Grill",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.teamName} - Player ${widget.playerIndex}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),

                        _buildQuestionTextField("اسم شخصية عامة", question1Controller),
                        const SizedBox(height: 15),
                        _buildQuestionTextField("فيلم", question2Controller),
                        const SizedBox(height: 15),
                        _buildQuestionTextField("أغنية", question3Controller),
                        const SizedBox(height: 15),
                        _buildQuestionTextField("مكان في مصر", question4Controller),
                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveAnswers,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Submit and Next Player",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTextField(String label, TextEditingController controller) {
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
        hintStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
