import 'package:flutter/material.dart';
import 'package:game/WinnerScreen.dart';
import 'dart:math';
import 'dart:async';
import 'package:game/game_data.dart';

class RoundThreeScreen extends StatefulWidget {
  const RoundThreeScreen({super.key});

  @override
  State<RoundThreeScreen> createState() => _RoundThreeScreenState();
}

class _RoundThreeScreenState extends State<RoundThreeScreen> {
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
    _loadNewAnswers();
    _startTimer();
    _generateNewWord();
  }

  void _loadNewAnswers() {
    Set<String> usedWords = GameData.usedWordsInRound1.union(GameData.usedWordsInRound2);
    _allAnswers = GameData.answers.values
        .expand((playerMap) => playerMap.values.expand((answersList) => answersList))
        .where((word) => !usedWords.contains(word))
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

  void _pauseResumeTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _generateNewWord() {
    if (_allAnswers.isNotEmpty && _currentTeamIndex < GameData.teams.length) {
      setState(() {
        _currentWord = _allAnswers.removeLast();
        GameData.usedWordsInRound3.add(_currentWord);
      });
    }
  }

  void _correctAnswer() {
    setState(() {
      String currentTeam = GameData.teams[_currentTeamIndex];
      GameData.addScore(currentTeam);
      _generateNewWord();
    });
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
      _announceWinner();
    }
  }

  void _announceWinner() {
    _timer?.cancel();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WinnerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
              SizedBox(height: screenHeight * 0.08),
              Text(
                "Final Round",
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
              SizedBox(height: screenHeight * 0.02),
              Text(
                GameData.teams.isNotEmpty ? "${GameData.teams[_currentTeamIndex]}" : "No teams available!",
                style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
              Text(
                _currentWord.isNotEmpty ? _currentWord : "No word available!",
                style: TextStyle(
                  fontSize: screenWidth * 0.13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.08),
              _buildButton(_pauseResumeTimer, _isPaused ? "Resume Timer" : "Pause Timer", _isPaused ? Colors.blue : Colors.orange),
              SizedBox(height: screenHeight * 0.02),
              _buildButton(_correctAnswer, "Change Word (Correct Answer)", Colors.green),
              SizedBox(height: screenHeight * 0.02),
              allTeamsPlayed
                  ? _buildButton(_announceWinner, "Show Winner 🏆", Colors.purple, icon: Icons.emoji_events)
                  : _buildButton(_nextTeam, "Next Team", Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(VoidCallback onPressed, String text, Color color, {IconData? icon}) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.45, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: icon != null
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(width: 6),
            Text(text),
          ],
        )
            : Text(text),
      ),
    );
  }
}