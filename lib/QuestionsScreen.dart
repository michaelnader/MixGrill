import 'package:flutter/material.dart';
import 'package:game/round1intro.dart';
import 'PlayerQuestionScreen.dart';

class QuestionsScreen extends StatelessWidget {
  final Map<String, int> teamData;

  const QuestionsScreen({super.key, required this.teamData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Very small app bar
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove default back button
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/b4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title with lighter gradient
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.blue.shade600, Colors.cyan.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    "Mix Grill",
                    style: TextStyle(
                      fontSize: screenWidth * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),

                // Team sections in a scrollable list
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: teamData.entries.where((entry) => entry.value >= 2).length,
                    itemBuilder: (context, index) {
                      final entry = teamData.entries.where((entry) => entry.value >= 2).elementAt(index);
                      return _buildTeamSection(context, entry.key, entry.value, screenWidth);
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Submit Button with animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.95, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoundOneIntro(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade400,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, screenHeight * 0.07),
                          elevation: 4,
                          shadowColor: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "Submit All",
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context, String teamName,
      int playerCount, double screenWidth) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
      decoration: BoxDecoration(
        color: Color(0xFF091653),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.people,
                  color: Colors.white,
                  size: screenWidth * 0.05,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Text(
                  "$teamName (Players: $playerCount)",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          ...List.generate(
            playerCount,
            (index) => _buildPlayerButton(context, teamName, index, screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerButton(BuildContext context, String teamName,
      int playerIndex, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Replace standard navigation with custom page route
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                  PlayerQuestionsScreen(
                    teamName: teamName,
                    playerIndex: playerIndex + 1,
                  ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOutCubic;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.blue.shade100,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.cyan.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.035,
                horizontal: screenWidth * 0.04,
              ),
              child: Row(
                children: [
                  // Wrap the icon in a Hero widget for shared element transition
                  Hero(
                    tag: 'player-icon-$teamName-$playerIndex',
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  // Wrap the text in a Hero widget
                  Hero(
                    tag: 'player-text-$teamName-$playerIndex',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        "Player ${playerIndex + 1} Questions",
                        style: TextStyle(
                          fontSize: screenWidth * 0.040,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: screenWidth * 0.04,
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
