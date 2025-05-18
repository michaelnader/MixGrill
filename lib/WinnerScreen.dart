import 'package:flutter/material.dart';
import 'package:game/game_data.dart';
import 'package:game/teamsregisteration.dart';
import 'package:audioplayers/audioplayers.dart';

class WinnerScreen extends StatefulWidget {
  const WinnerScreen({super.key});

  @override
  State<WinnerScreen> createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _playWinnerSound();
  }

  void _playWinnerSound() async {
    await _audioPlayer.play(AssetSource('winner.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String winner = GameData.getWinner();
    bool isDraw = winner == "DRAW";

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
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: screenWidth * 0.9,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // Remove the black background color
                            // color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                isDraw ? "It's a Draw!" : "Winner!",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.1,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.black,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              isDraw
                                  ? Text(
                                      "Multiple teams tied with the highest score!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.06,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    )
                                  : Text(
                                      winner,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.08,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Icon(
                                  Icons.emoji_events,
                                  size: screenWidth * 0.25,
                                  color: Colors.amber,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              // Only show the Winner text if not a draw
                              if (!isDraw) 
                                SlideTransition(
                                  position: _slideAnimation,
                                  child: Text(
                                    "🏆 Winner 🏆",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.12,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: [Colors.cyan, Colors.white],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(Rect.fromLTWH(
                                            0.0, 0.0, screenWidth, 70.0)),
                                    ),
                                  ),
                                ),
                              if (!isDraw) SizedBox(height: screenHeight * 0.04),
                              if (!isDraw)
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    winner,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              SizedBox(height: screenHeight * 0.02),
                              if (!isDraw)
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Text(
                                    "Final Score: ${GameData.teamScores[winner]}",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.08,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              SizedBox(height: screenHeight * 0.05),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.08),
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        GameData.resetGame();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Teams()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightBlueAccent,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * 0.02),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        "Play Again",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                "Final Scores:",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              ...GameData.teamScores.entries.map((entry) {
                                bool isWinner = !isDraw && entry.key == winner;
                                return Container(
                                  width: screenWidth * 0.7,
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "${entry.key}: ${entry.value}",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: isWinner
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isWinner
                                          ? Colors.deepOrange
                                          : Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
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
}
