import 'package:flutter/material.dart';
import 'package:game/WinnerScreen.dart'; // Replace with your next screen
import 'dart:math';
import 'package:game/game_data.dart';
import 'dart:async';

class RoundThreeScreen extends StatefulWidget {
  const RoundThreeScreen({super.key});

  @override
  State<RoundThreeScreen> createState() => _RoundThreeScreenState();
}

class _RoundThreeScreenState extends State<RoundThreeScreen> {
  final Random _random = Random();
  int _currentTeamIndex = 0;
  String _currentWord = "";
  String _currentCategory = ""; // Variable for category
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
    _generateNewWord();
    _startTimer();
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

  void _pauseOrResumeTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _generateNewWord() {
    // Use the GameData method to get a random word and its category
    final wordData =
        GameData.getRandomWord(3, GameData.teams[_currentTeamIndex]);

    if (wordData != null) {
      setState(() {
        _currentWord = wordData['word'] ?? "";
        _currentCategory = wordData['category'] ?? "Unknown Category";
      });
    } else {
      // No new words available, check if there are skipped words
      final skippedWordData =
          GameData.getSkippedWord(GameData.teams[_currentTeamIndex], 3);

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
      _isTransitioning = true;
    });
  }

  void _startNextTeam() {
    if (_currentTeamIndex < GameData.teams.length - 1) {
      setState(() {
        _isTransitioning = false;
        _currentTeamIndex++;
        _timeLeft = 60; // Reset the timer for the next team
        _generateNewWord();
      });
      _startTimer();
    } else {
      _timer?.cancel();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const WinnerScreen()), // Replace with your next screen
      );
    }
  }

  void _correctAnswer() {
    // First add the score for the current team
    GameData.teamScores[GameData.teams[_currentTeamIndex]] =
        (GameData.teamScores[GameData.teams[_currentTeamIndex]] ?? 0) + 1;

    // Subtract 5 seconds from timer, but don't go below 0
    setState(() {
      _timeLeft = _timeLeft > 5 ? _timeLeft - 5 : 0;
    });

    // Check if there are any words available before generating a new word
    final wordData =
        GameData.getRandomWord(3, GameData.teams[_currentTeamIndex]);
    final skippedWordData =
        GameData.getSkippedWord(GameData.teams[_currentTeamIndex], 3);

    if (wordData == null && skippedWordData == null) {
      // No words available, navigate to winner screen immediately
      _timer?.cancel();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WinnerScreen()),
      );
    } else {
      // Words are still available, generate a new word
      setState(() {
        _generateNewWord();
      });
    }
  }

  void _skipWord() {
    setState(() {
      // Save the current word and category
      String skippedWord = _currentWord;

      // Remove from used words set if it exists
      if (skippedWord.isNotEmpty) {
        GameData.usedWordsInRound3.remove(skippedWord);

        // Add to skipped words for this team
        GameData.addSkippedWord(
            GameData.teams[_currentTeamIndex], 3, skippedWord);
      }

      _timeLeft = _timeLeft > 15
          ? _timeLeft - 15
          : 0; // Subtract 10 seconds, but don't go below 0
      _generateNewWord();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          child: _isTransitioning 
              ? _buildTransitionUI() 
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildRoundThreeUI(),
                ),
        ),
      ),
    );
  }

  Widget _buildRoundThreeUI() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.08),
          child: Text(
            "Round Three",
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
        // Add category display

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
          onPressed: _skipWord,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: Size(screenWidth * 0.45, screenHeight * 0.06),
          ),
          child: const Text("Skip Word (-15s)"),
        ),
        SizedBox(height: screenHeight * 0.02),
        ElevatedButton(
          onPressed: _correctAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(screenWidth * 0.45, screenHeight * 0.06),
          ),
          child: const Text("Correct Answer (-5s)"),
        ),
      ],
    );
  }

  Widget _buildTransitionUI() {
    String nextTeam = "No more teams";
    bool allTeamsPlayed = _currentTeamIndex == GameData.teams.length - 1;

    if (!allTeamsPlayed) {
      nextTeam = GameData.teams[_currentTeamIndex + 1];
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${GameData.teams[_currentTeamIndex]}'s Turn Ended!",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Score: ${GameData.teamScores[GameData.teams[_currentTeamIndex]] ?? 0}",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            allTeamsPlayed ? "All teams have played!" : "Next Team: $nextTeam",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.cyan,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _startNextTeam,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(MediaQuery.of(context).size.width * 0.45, 50),
            ),
            child: Text(allTeamsPlayed ? "Go to Results" : "Start Next Team"),
          ),
        ],
      ),
    );
  }
}
