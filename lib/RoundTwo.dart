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
    bool allTeamsPlayed = _currentTeamIndex == GameData.teams.length - 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Text(
                    "Round Two",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Colors.cyan, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 142.0, top: 20.0),
                child: Text(
                  GameData.teams.isNotEmpty
                      ? " ${GameData.teams[_currentTeamIndex]}"
                      : "No teams available!",
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: Text(
                  "$_timeLeft seconds left",
                  style: const TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _currentWord.isNotEmpty ? _currentWord : "No word available!",
                  style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 100),
              Center(
                child: ElevatedButton(
                  onPressed: _pauseOrResumeTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(_isPaused ? "Resume Timer" : "Pause Timer"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _correctAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Change Word (Correct Answer)"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: !allTeamsPlayed
                    ? ElevatedButton(
                  onPressed: _nextTeam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Next Team"),
                )
                    : ElevatedButton.icon(
                  onPressed: _goToRoundThree,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next Round →"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
