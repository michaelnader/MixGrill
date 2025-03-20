import 'package:flutter/material.dart';
import 'package:game/RoundOne.dart';

class RoundOneIntro extends StatefulWidget {
  const RoundOneIntro({super.key});

  @override
  State<RoundOneIntro> createState() => _RoundOneIntroState();
}

class _RoundOneIntroState extends State<RoundOneIntro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
              SizedBox(height: screenHeight * 0.06),

              // Round One Title
              Text(
                "Round One",
                style: TextStyle(
                  fontSize: screenWidth * 0.12,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Colors.cyan, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 70.0)),
                ),
              ),

              SizedBox(height: screenHeight * 0.08),

              // Circular Image with Scale Animation
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.3),
                  child: Image.asset("assets/tamsil.jpg", height: screenHeight * 0.28),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  "حد بيطلع بيمثل الحاجة اللى هتطلعله للفريق فى 60 ثانية و بيقول نوعها الاول قبل ما بيمثل يعنى لو طلعله اغنية 'انت الحظ' هيقول اغنية بعدين يبدأ يمثل",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: navigateToRoundOne,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
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
