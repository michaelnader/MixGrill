import 'package:flutter/material.dart';
import 'dart:math';
import 'package:game/game_data.dart';
import 'package:game/RoundOne.dart';

class RoundOneIntro extends StatefulWidget {
  const RoundOneIntro({super.key});

  @override
  State<RoundOneIntro> createState() => _RoundOneIntroState();
}

class _RoundOneIntroState extends State<RoundOneIntro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Start slightly below
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateToRoundOne() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RoundOneScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Round One Title with Gradient Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  "Round One",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 70.0)),
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Circular Image with Scale Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset("assets/tamsil.jpg", height: 250),
                ),
              ),
              const SizedBox(height: 60),

              // Description with Slide Animation
              SlideTransition(
                position: _slideAnimation,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "حد بيطلع بيمثل الحاجة اللى هتطلعله للفريق فى 60 ثانية و بيقول نوعها الاول قبل ما بيمثل يعنى لو طلعله اغنية 'انت الحظ' هيقول اغنية بعدين يبدأ يمثل",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 150),

              // Continue Button
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: navigateToRoundOne,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
