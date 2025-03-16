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
                    "Final Round",
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
                  onPressed: _pauseResumeTimer,
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
                child: allTeamsPlayed
                    ? ElevatedButton.icon(
                  onPressed: _announceWinner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text("Show Winner 🏆"),
                )
                    : ElevatedButton(
                  onPressed: _nextTeam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("Next Team"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}