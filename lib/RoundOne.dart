import 'package:flutter/material.dart';
import 'package:game/game_data.dart';
import 'dart:math';
import 'dart:async';
import 'package:game/RoundTwoIntro.dart';

class RoundOneScreen extends StatefulWidget {
  const RoundOneScreen({super.key});

  @override
  State<RoundOneScreen> createState() => _RoundOneScreenState();
}

class _RoundOneScreenState extends State<RoundOneScreen> {
  final Random _random = Random();
  int _currentTeamIndex = 0;
  String _currentWord = "";
  String _currentCategory = "";
  int _timeLeft = 60;
  Timer? _timer;
  bool _isPaused = false;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _initializeRound();
  }

  void _initializeRound() {
    // Generate a new word using the updated GameData method
    _generateNewWord();

    if (_currentWord.isNotEmpty) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else if (_timeLeft == 0) {
        timer.cancel();
        _startTransition();
      }
    });
  }

  void _togglePauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _generateNewWord() {
    // Use the new GameData method to get a random word and its category
    // Pass the current team name to avoid words they've skipped
    final wordData =
        GameData.getRandomWord(1, GameData.teams[_currentTeamIndex]);

    if (wordData != null) {
      setState(() {
        _currentWord = wordData['word'] ?? "";
        _currentCategory = wordData['category'] ?? "Unknown Category";
      });
    } else {
      // No new words available, check if there are skipped words
      final skippedWordData =
          GameData.getSkippedWord(GameData.teams[_currentTeamIndex], 1);

      if (skippedWordData != null) {
        setState(() {
          _currentWord = skippedWordData['word'] ?? "";
          _currentCategory = skippedWordData['category'] ?? "Unknown Category";
          // Show a message that this is a skipped word
        });
      } else {
        setState(() {
          _currentWord = "";
          _currentCategory = "No words available";
        });
      }
    }
  }

  void _startTransition() {
    setState(() {
      _isTransitioning = true; // Enter transition state
    });
  }

  void _startNextTeam() {
    if (_currentTeamIndex < GameData.teams.length - 1) {
      setState(() {
        _isTransitioning = false; // Exit transition state
        _currentTeamIndex++;
        _timeLeft = 60;
        _generateNewWord();
      });
      _startTimer();
    } else {
      // All teams have played, move to Round Two
      _timer?.cancel();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RoundTwoIntro()),
      );
    }
  }

  void _correctAnswer() {
    setState(() {
      String currentTeam = GameData.teams[_currentTeamIndex];
      GameData.addScore(currentTeam);
      _generateNewWord();
    });
    print("Current Scores: ${GameData.teamScores}");
  }

  void _skipWord() {
    setState(() {
      // Save the current word and category
      String skippedWord = _currentWord;

      // Remove from used words set if it exists
      if (skippedWord.isNotEmpty) {
        GameData.usedWordsInRound1.remove(skippedWord);

        // Add to skipped words for this team
        GameData.addSkippedWord(
            GameData.teams[_currentTeamIndex], 1, skippedWord);
      }

      _timeLeft = _timeLeft > 10
          ? _timeLeft - 10
          : 0; // Subtract 10 seconds, but don't go below 0
      _generateNewWord();
    });
    print("Current Scores: ${GameData.teamScores}");
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: _isTransitioning 
              ? _buildTransitionUI() 
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildRoundOneUI(),
                ),
        ),
      ),
    );
  }

  Widget _buildRoundOneUI() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.08),
        Text(
          "Round One",
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
          GameData.teams.isNotEmpty
              ? "${GameData.teams[_currentTeamIndex]}"
              : "No teams available!",
          style: TextStyle(
            fontSize: screenWidth * 0.09,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        SizedBox(height: screenHeight * 0.02),
        Text(
          "Category: $_currentCategory",
          style: TextStyle(
            fontSize: screenWidth * 0.07,
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.08),
        GradientButton(
          onPressed: _togglePauseResume,
          text: _isPaused ? "Resume Timer" : "Pause Timer",
          color: _isPaused ? Colors.blue : Colors.orange,
        ),
        SizedBox(height: screenHeight * 0.02),
        GradientButton(
          onPressed: _skipWord,
          text: "Skip Word (-10s)",
          color: Colors.red,
        ),
        SizedBox(height: screenHeight * 0.02),
        GradientButton(
          onPressed: _correctAnswer,
          text: "Correct Answer",
          color: Colors.green,
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildTransitionUI() {
    String nextTeam = "No more teams";
    if (_currentTeamIndex + 1 < GameData.teams.length) {
      nextTeam = GameData.teams[_currentTeamIndex + 1];
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              textAlign: TextAlign.center,
              "${GameData.teams[_currentTeamIndex]}'s Turn Ended!",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Score: ${GameData.teamScores[GameData.teams[_currentTeamIndex]] ?? 0}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "Next Team: $nextTeam",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.cyan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          GradientButton(
            onPressed: _startNextTeam,
            text: "Start Next Team",
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}

// Reusable GradientButton Widget
class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final IconData? icon;

  const GradientButton({
    required this.onPressed,
    required this.text,
    required this.color,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
