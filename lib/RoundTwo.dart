import 'package:flutter/material.dart';
import 'package:game/Round3Intro.dart';
import 'dart:math';
import 'package:game/game_data.dart';
import 'dart:async';

class RoundTwoScreen extends StatefulWidget {
  const RoundTwoScreen({super.key});

  @override
  State<RoundTwoScreen> createState() => _RoundTwoScreenState();
}

class _RoundTwoScreenState extends State<RoundTwoScreen> {
  final Random _random = Random();
  List<String> _allAnswers = [];
  int _currentTeamIndex = 0;
  String _currentWord = "";
  int _timeLeft = 60;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _loadAllAnswers();
    _startTimer();
    _generateNewWord();
  }

  void _loadAllAnswers() {
    _allAnswers = GameData.answers.values
        .expand((playerMap) => playerMap.values.expand((answersList) => answersList))
        .toList();
    _allAnswers.shuffle();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_isPaused) {
        setState(() {
          _timeLeft--;
        });
      } else if (_timeLeft == 0) {
        timer.cancel();
        _nextTeam();
      }
    });
  }

  void _pauseOrResumeTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _generateNewWord() {
    if (_allAnswers.isNotEmpty) {
      setState(() {
        _currentWord = _allAnswers.removeLast();
        GameData.usedWordsInRound2.add(_currentWord);
      });
    }
  }

  void _nextTeam() {
    if (_currentTeamIndex < GameData.teams.length - 1) {
      setState(() {
        _currentTeamIndex++;
        _timeLeft = 60;
        _generateNewWord();
      });
      _startTimer();
    } else {
      _timer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All teams have completed Round Two!")),
      );
    }
  }

  void _correctAnswer() {
    setState(() {
      GameData.teamScores[GameData.teams[_currentTeamIndex]] =
          (GameData.teamScores[GameData.teams[_currentTeamIndex]] ?? 0) + 1;
      _generateNewWord();
    });
  }

  void _goToRoundThree() {
    _timer?.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RoundThreeIntro()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool allTeamsPlayed = _currentTeamIndex == GameData.teams.length - 1;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.08),
                child: Text(
                  "Round two",
                  style: TextStyle(
                    fontSize: screenWidth * 0.11,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0.0, 0.0, screenWidth, 70.0)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Text(
                  GameData.teams.isNotEmpty
                      ? "${GameData.teams[_currentTeamIndex]}"
                      : "No teams available!",
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "$_timeLeft seconds left",
                style: TextStyle(
                  fontSize: screenWidth * 0.09,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  _currentWord.isNotEmpty ? _currentWord : "No word available!",
                  style: TextStyle(
                    fontSize: screenWidth * 0.13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenHeight * 0.08),
              ElevatedButton(
                onPressed: _pauseOrResumeTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,

                  minimumSize: Size(screenWidth * 0.45, screenHeight * 0.06),
                ),
                child: Text(_isPaused ? "Resume Timer" : "Pause Timer"),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: _correctAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(screenWidth * 0.45, screenHeight * 0.06),
                ),
                child: const Text("Change Word (Correct Answer)"),
              ),
              SizedBox(height: screenHeight * 0.02),
              !allTeamsPlayed
                  ? ElevatedButton(
                onPressed: _nextTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,

                  minimumSize: Size(screenWidth * 0.45, screenHeight * 0.06),
                ),
                child: const Text("Next Team"),
              )
                  : ElevatedButton.icon(
                onPressed: _goToRoundThree,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  foregroundColor: Colors.white,

                  minimumSize: Size(screenWidth * 0.45, screenHeight * 0.06),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Next Round →"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
