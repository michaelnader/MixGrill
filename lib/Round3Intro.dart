import 'package:flutter/material.dart';
import 'package:game/RoundThree.dart';

class RoundThreeIntro extends StatefulWidget {
  const RoundThreeIntro({super.key});

  @override
  State<RoundThreeIntro> createState() => _RoundThreeIntroState();
}

class _RoundThreeIntroState extends State<RoundThreeIntro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateToRoundThree() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoundThreeScreen()),
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
              // Title with Gradient
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    "Round Three",
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
              ),
              const SizedBox(height: 50),
              // Animated Circular Image
              FadeTransition(
                opacity: _fadeAnimation,
                child: ClipOval(
                  child: Image.asset(
                    "assets/last.jpg",
                    height: 300,
                    width: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Text Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      "اخر جولة و اسهل واحدة ان اللى بيطلع بيقول للفريق كلمة من الحاجة اللى طلعتله "
                          "مثلا لو جاله اغنية 'انت الحظ' ممكن ييقول 'الحظ', فى الجولة دى مش بنقول النوع "
                          "يعنى مش هيقول 'اغنية'! طب لو الحاجة اصلا كلمة واحدة بيلعبها زى الجولة اللى فاتت.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              // Continue Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: navigateToRoundThree,
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
